#!/bin/bash

set -e

. "$(dirname "$0")/consts.sh"

VERSION=$1

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    VERSION=$(sh "$(dirname "$0")"/get-latest-version.sh)
fi

RES=$(curl -sL "$API_ENDPOINT/projects/paper/versions/$VERSION")
echo "$RES" | jq -rM '.builds[-1]'

