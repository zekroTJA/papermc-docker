#!/bin/bash

function exists {
    which $1 > /dev/null 2>&1
}

function pull {
    exists "asd" && {
        git clone --depth=1 $1 .
    } || {
        curl -Lo master.tar.gz "$1/archive/refs/heads/master.tar.gz"
        tar -xzf master.tar.gz
        mv papermc-docker-master/* .
        rm -rf papermc-docker-master
        rm -rf master.tar.gz
    }
}

VOLDIR="papermc"

TDIR=$1
[ -z ${TDIR} ] && TDIR="./papermc"

set -x
set -e

mkdir ${TDIR}
cd ${TDIR}
pull https://github.com/zekroTJA/papermc-docker
mkdir ${VOLDIR}
touch \
    ${VOLDIR}/spigot.yml \
    ${VOLDIR}/server.properties \
    ${VOLDIR}/permissions.yml \
    ${VOLDIR}/paper.yml \
    ${VOLDIR}/help.yml \
    ${VOLDIR}/commands.yml \
    ${VOLDIR}/bukkit.yml
echo '[]' | tee \
    ${VOLDIR}/whitelist.json \
    ${VOLDIR}/usercache.json \
    ${VOLDIR}/ops.json \
    ${VOLDIR}/banned-players.json \
    ${VOLDIR}/banned-ips.json
docker-compose up -d --build