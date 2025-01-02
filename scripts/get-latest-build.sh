#!/bin/bash

source "$(dirname "$0")/utils.sh"

if is_true "$DEBUG_MODE"; then
    set -x
fi

set -e

. "$(dirname "$0")/consts.sh"

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    VERSION=$(sh "$(dirname "$0")"/get-latest-version.sh)
fi

RES=$(curl -sL "$API_ENDPOINT/projects/paper/versions/$VERSION")
echo "$RES" | jq -rM '.builds[-1]'

