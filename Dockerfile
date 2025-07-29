ARG MINEBASE_IMAGE="jdk-21"

# ---------------------------------------------------

FROM ghcr.io/zekrotja/minebase:$MINEBASE_IMAGE

RUN apt-get update -y &&\
    apt-get install -y coreutils

COPY scripts/ scripts/

RUN dos2unix ./scripts/*.sh /usr/bin/rcon
RUN chmod +x scripts/*.sh

RUN mkdir -p /var/mcserver && \
    mkdir -p /etc/mcserver/worlds && \
    mkdir -p /etc/mcserver/plugins && \
    mkdir -p /etc/mcserver/config && \
    mkdir -p /etc/mcserver/locals

ENV PROPERTIES_LOCATION="/etc/mcserver/locals/server.properties" \
    BACKUP_LOCATION="/etc/mcserver/worlds"

COPY recommendet-jvm-args.txt .

ENV JVM_PARAMS="@/var/mcserver/recommendet-jvm-args.txt"
