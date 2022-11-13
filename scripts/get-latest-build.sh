#!/bin/sh

source "$(dirname $0)/consts.sh"

VERSION=$1

[ -z $VERSION ] || [ "$VERSION" == "latest" ] \
    && VERSION=$(sh $(dirname $0)/get-latest-version.sh)

RES=$(curl -sL "$API_ENDPOINT/projects/paper/versions/$VERSION")
echo $RES | jq -rM .builds[-1]

