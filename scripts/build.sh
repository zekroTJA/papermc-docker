#!/bin/bash

PURPLE="\033[0;35m"
RESET="\033[0m"

set -e

. "$(dirname "$0")/consts.sh"

CURR_VER_FILE="/tmp/current-server-version"

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    VERSION=$(sh "$(dirname "$0")"/get-latest-version.sh)
fi

if [ -z "$BUILD" ] || [ "$BUILD" == "latest" ]; then
    BUILD=$(bash "$(dirname "$0")"/get-latest-build.sh "$VERSION")
fi


echo "Paper version $VERSION+$BUILD"
echo "-----------------------------"

CURR_VER=$([ -f $CURR_VER_FILE ] && cat $CURR_VER_FILE || echo "")

if [ "$CURR_VER" == "$VERSION+$BUILD" ] && [ "$USE_CACHE" == "true" ]; then
    echo "Using binary from cache..."
    exit 0
fi

set +e
RES=$(curl -sLf "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD")
status=$?
set -e

if [ $status -ne 0 ]; then
    echo -e "${PURPLE}ERROR: No build with version $VERSION and build $BUILD existent!${RESET}"
    echo "Download Url: $API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD"
    exit 2
fi
jar_name=$(echo "$RES" | jq -rM '.downloads.application.name')

curl -Lo paper.jar "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD/downloads/$jar_name"
echo "$VERSION+$BUILD" > $CURR_VER_FILE
