#!/bin/bash

source "$(dirname $0)/consts.sh"

CURR_VER_FILE="/tmp/current-server-version"

VERSION=$1
BUILD=$2
USE_CACHE=$3

[ -z $VERSION ] || [ "$VERSION" == "latest" ] \
    && VERSION=$(sh $(dirname $0)/get-latest-version.sh)

[ -z $BUILD ] || [ "$BUILD" == "latest" ] \
    && BUILD=$(sh $(dirname $0)/get-latest-build.sh $VERSION)

echo "Paper version $VERSION+$BUILD"
echo "-----------------------------"

CURR_VER=$([ -f $CURR_VER_FILE ] && cat $CURR_VER_FILE || echo "")

[ "$CURR_VER" == "$VERSION+$BUILD" ] && [ "$USE_CACHE" == "1" ] \
    && echo "Using binary from cache..." \
    && exit

RES=$(curl -sL "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD")
jar_name=$(echo $RES | jq -rM .downloads.application.name)

#echo "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD/downloads/$jar_name"
curl -Lo paper.jar "$API_ENDPOINT/projects/paper/versions/$VERSION/builds/$BUILD/downloads/$jar_name"
echo "$VERSION+$BUILD" > $CURR_VER_FILE
