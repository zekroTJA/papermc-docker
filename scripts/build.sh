#!/bin/bash

set -e

. "$(dirname "$0")/consts.sh"

CURR_VER_FILE="/tmp/current-server-version"

VERSION=$1
BUILD=$2
USE_CACHE=$3

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    VERSION=$(sh "$(dirname "$0")"/get-latest-version.sh)
fi

if [ -z "$BUILD" ] || [ "$BUILD" == "latest" ]; then
    BUILD=$(sh "$(dirname "$0")"/get-latest-build.sh "$VERSION")
fi


echo "Paper version $VERSION+$BUILD"
echo "-----------------------------"

CURR_VER=$([ -f $CURR_VER_FILE ] && cat $CURR_VER_FILE || echo "")

if [ "$CURR_VER" == "$VERSION+$BUILD" ] && [ "$USE_CACHE" == "true" ]; then
    echo "Using binary from cache..."
    exit 0
fi

RES=$(curl -sL "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD")
jar_name=$(echo "$RES" | jq -rM '.downloads.application.name')

curl -Lo paper.jar "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD/downloads/$jar_name"
echo "$VERSION+$BUILD" > $CURR_VER_FILE
