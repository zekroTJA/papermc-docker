#!/bin/bash

source "$(dirname "$0")/utils.sh"

if is_true "$DEBUG_MODE"; then
    set -x
fi

set -e

. "$(dirname "$0")/consts.sh"

# This query is based on the example published by papermc.
# https://docs.papermc.io/misc/downloads-api/#getting-the-latest-version
# Archived version: https://web.archive.org/web/20250726220949/https://docs.papermc.io/misc/downloads-api/#getting-the-latest-version

LATEST_VERSION=$(curl -s -H "User-Agent: $API_USER_AGENT" "${API_ENDPOINT}/projects/paper" | \
    jq -r '.versions | to_entries[0] | .value[0]')

echo "$LATEST_VERSION"