#!/bin/bash

source "$(dirname "$0")/utils.sh"

if is_true "$DEBUG_MODE"; then
    set -x
fi

set -e

cd /etc/mcserver/locals

echo "eula=true" | tee eula.txt

java -jar \
    -Xms${XMS} -Xmx${XMX} ${JVM_PARAMS} \
    /var/mcserver/paper.jar \
        --commands-settings /etc/mcserver/config/commands.yml \
        --plugins           /etc/mcserver/plugins \
        --spigot-settings   /etc/mcserver/config/spigot.yml \
        --world-container   /etc/mcserver/worlds \
        --bukkit-settings   /etc/mcserver/config/bukkit.yml