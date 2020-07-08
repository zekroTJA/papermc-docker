FROM openjdk:12-alpine

WORKDIR /var/server

ARG EULA=false

ADD ./scripts ./scripts

RUN apk add curl jq \
    && echo "eula=$EULA" > eula.txt

ENV VERSION=latest \
    BUILD=latest \
    CACHE_DOWNLOAD=1 \
    XMS=1G \
    XMX=2G \
    JAVA_ARGS=""

EXPOSE 25565 25575

CMD sh ./scripts/prep.sh $VERSION $BUILD $CACHE_DOWNLOAD \
    && java -jar -Xms${XMS} -Xmx${XMX} $JAVA_ARGS paper.jar nogui


# FILES AND DIRS YOU MAY WANT TO BIND
#
# /var/server/logs
# /var/server/plugins
# /var/server/world
# /var/server/world_nether
# /var/server/world_the_end
#
# /var/server/banned-ips.json
# /var/server/banned-players.json
# /var/server/bukkit.yml
# /var/server/commands.yml
# /var/server/help.yml
# /var/server/ops.json
# /var/server/paper.yml
# /var/server/permissions.yml
# /var/server/server.properties
# /var/server/spigot.yml
# /var/server/usercache.json
# /var/server/whitelist.json