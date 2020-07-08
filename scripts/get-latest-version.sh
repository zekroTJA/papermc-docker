#!/bin/sh

source "$(dirname $0)/consts.sh"

RES=$(curl -sL "$API_ENDPOINT/paper")

echo $RES | jq -rM .versions[0]