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


echo "Paper version $VERSION+$BUILD"
echo "-----------------------------"

CURR_VER=$([ -f $CURR_VER_FILE ] && cat $CURR_VER_FILE || echo "")

if [ "$CURR_VER" == "$VERSION+$BUILD" ] && [ "$USE_CACHE" == "true" ]; then
    echo "Using binary from cache..."
    exit 0
fi

# This query is based on the example published by papermc.
# https://docs.papermc.io/misc/downloads-api/#downloading-the-latest-stable-build
# Archived version: https://web.archive.org/web/20250726220949/https://docs.papermc.io/misc/downloads-api/#downloading-the-latest-stable-build

BUILD_INFO_URL="${API_ENDPOINT}/projects/paper/versions/${VERSION}/builds/$BUILD"
BUILD_INFO=$(curl -s -H "User-Agent: $USER_AGENT" "${BUILD_INFO_URL}")

# Check if the API returned an error
if echo "$BUILD_INFO" | jq -e '.ok == false' > /dev/null 2>&1; then
  ERROR_MSG=$(echo "$BUILD_INFO" | jq -r '.message // "Unknown error"')
  echo -e "[ ${PURPLE}ERROR ${RESET}]${PURPLE} Error with version $VERSION and build $BUILD!${RESET}"
  echo -e "[ ${PURPLE}ERROR ${RESET}]${PURPLE} $ERROR_MSG${RESET}"
  echo -e "[ ${PURPLE}ERROR ${RESET}]${PURPLE} Used build info url: ${BUILD_INFO_URL}${RESET}"
  exit 2
fi

JAR_DOWNLOAD_URL=$(echo "$BUILD_INFO" | jq -r '.downloads."server:default".url')

# Check if download url is provided
if [ "$JAR_DOWNLOAD_URL" = "null" ]; then
  echo -e "[ ${PURPLE}ERROR ${RESET}]${PURPLE} Error with version $VERSION and build $BUILD!${RESET}"
  echo -e "[ ${PURPLE}ERROR ${RESET}]${PURPLE} No download url was provided by PaperMC!${RESET}"
  echo -e "[ ${PURPLE}ERROR ${RESET}]${PURPLE} Used build info url: ${BUILD_INFO_URL}${RESET}"
  exit 3
fi

# Download the specified Paper version
curl -Lo paper.jar "$JAR_DOWNLOAD_URL"

echo "$VERSION+$BUILD" > $CURR_VER_FILE
