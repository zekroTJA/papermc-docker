#!/bin/bash

source ./scripts/utils.sh

if is_true "$DEBUG_MODE"; then
    set -x
fi

set -e

. "$(dirname "$0")/consts.sh"

CURR_VER_FILE="/tmp/current-server-version"

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    VERSION=$(bash "$(dirname "$0")"/get-latest-version.sh)
fi

if [ -z "$BUILD" ] || [ "$BUILD" == "latest" ]; then
    BUILD=$(bash "$(dirname "$0")"/get-latest-build.sh)
fi

echo -e "[ ${CYAN}INFO${RESET} ] Using Paper version: $VERSION+$BUILD"
echo -e "[ ${CYAN}INFO${RESET} ] -----------------------------"

CURR_VER=$([ -f "$CURR_VER_FILE" ] && cat "$CURR_VER_FILE" || echo "")

if [ "$CURR_VER" == "$VERSION+$BUILD" ] && [ "$USE_CACHE" == "true" ]; then
    echo -e "[ ${CYAN}INFO${RESET} ] Using binary from cache."
    exit 0
fi

BUILD_INFO_URL="${API_ENDPOINT}/projects/paper/versions/${VERSION}/builds/$BUILD"
BUILD_INFO=$(curl -s -H "User-Agent: $USER_AGENT" "${BUILD_INFO_URL}")

# Check if the API returned an error
if echo "$BUILD_INFO" | jq -e '.ok == false' > /dev/null 2>&1; then
  ERROR_MSG=$(echo "$BUILD_INFO" | jq -r '.message // "Unknown error"')
  echo -e "[ ${PURPLE}ERROR${RESET} ] Failed to retrieve build info for version $VERSION, build $BUILD."
  echo -e "[ ${PURPLE}ERROR${RESET} ] $ERROR_MSG"
  echo -e "[ ${PURPLE}ERROR${RESET} ] Build info URL: $BUILD_INFO_URL"
  exit 2
fi

JAR_DOWNLOAD_URL=$(echo "$BUILD_INFO" | jq -r '.downloads."server:default".url')

if [ "$JAR_DOWNLOAD_URL" = "null" ]; then
  echo -e "[ ${PURPLE}ERROR${RESET} ] No download URL provided for version $VERSION, build $BUILD."
  echo -e "[ ${PURPLE}ERROR${RESET} ] Build info URL: $BUILD_INFO_URL"
  exit 3
fi

# Download the specified Paper version
echo -e "[ ${CYAN}INFO${RESET} ] Starting jar download."
curl -Lso paper.jar "$JAR_DOWNLOAD_URL"
echo -e "[ ${CYAN}INFO${RESET} ] Download completed successfully."

# Checksum verification
EXPECTED_CHECKSUM=$(echo "$BUILD_INFO" | jq -r '.downloads."server:default".checksums.sha256')

if [ "$EXPECTED_CHECKSUM" = "null" ] || [ -z "$EXPECTED_CHECKSUM" ]; then
  echo -e "[ ${CYAN}WARN${RESET} ] No checksum provided by PaperMC — skipping verification."
else
  echo -e "[ ${CYAN}INFO${RESET} ] Verifying checksum..."
  ACTUAL_CHECKSUM=$(sha256sum "paper.jar" | awk '{print $1}')

  if [ "$EXPECTED_CHECKSUM" = "$ACTUAL_CHECKSUM" ]; then
    echo -e "[ ${CYAN}INFO${RESET} ] Checksum verification passed."
  else
    echo -e "[ ${PURPLE}ERROR${RESET} ] Checksum mismatch detected!"
    echo -e "[ ${PURPLE}ERROR${RESET} ] Expected: $EXPECTED_CHECKSUM"
    echo -e "[ ${PURPLE}ERROR${RESET} ] Actual:   $ACTUAL_CHECKSUM"
    echo -e "[ ${PURPLE}ERROR${RESET} ] Build info URL: $BUILD_INFO_URL"
    echo -e "[ ${PURPLE}ERROR${RESET} ] Download URL:   $JAR_DOWNLOAD_URL"
    exit 4
  fi
fi

echo "$VERSION+$BUILD" > "$CURR_VER_FILE"
