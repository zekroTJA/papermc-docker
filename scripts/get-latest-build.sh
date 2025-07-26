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

# This query is based on the example published by papermc.
# https://docs.papermc.io/misc/downloads-api/#getting-the-latest-stable-build-number
# Archived version: https://web.archive.org/web/20250726220949/https://docs.papermc.io/misc/downloads-api/#getting-the-latest-stable-build-number

LATEST_BUILD=$(curl -s -H "User-Agent: $USER_AGENT" "${API_ENDPOINT}/projects/paper/versions/${VERSION}/builds" | \
  jq -r 'map(select(.channel == "STABLE")) | .[0] | .id')

if [ "$LATEST_BUILD" != "null" ]; then
  echo "$LATEST_BUILD"
else
  echo "No stable build for version $MINECRAFT_VERSION found"
  exit 1
fi