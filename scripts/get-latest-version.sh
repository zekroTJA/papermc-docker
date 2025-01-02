#!/bin/bash

source "$(dirname "$0")/utils.sh"

if is_true "$DEBUG_MODE"; then
    set -x
fi

set -e

. "$(dirname "$0")/consts.sh"

RES=$(curl -sL "$API_ENDPOINT/projects/paper")

echo "$RES" | jq -rM '.versions[-1]'


