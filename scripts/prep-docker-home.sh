#!/bin/bash

mkdir -p ./papermc

touch ./papermc/bukkit.yml
touch ./papermc/commands.yml
touch ./papermc/help.yml
touch ./papermc/paper.yml
touch ./papermc/permissions.yml
touch ./papermc/server.properties
touch ./papermc/spigot.yml
echo "[]" > ./papermc/usercache.json
echo "[]" > ./papermc/whitelist.json
echo "[]" > ./papermc/banned-ips.json
echo "[]" > ./papermc/banned-players.json
echo "[]" > ./papermc/ops.json