#!/bin/bash

set -x
set -e

mkdir paper
cd paper
git clone https://github.com/zekroTJA/papermc-docker .
mkdir papermc
touch \
    papermc/spigot.yml \
    papermc/server.properties \
    papermc/permissions.yml \
    papermc/paper.yml \
    papermc/help.yml \
    papermc/commands.yml \
    papermc/bukkit.yml
echo '[]' > papermc/whitelist.json
echo '[]' > papermc/usercache.json
echo '[]' > papermc/ops.json
echo '[]' > papermc/banned-players.json
echo '[]' > papermc/banned-ips.json
docker-compose up -d --build