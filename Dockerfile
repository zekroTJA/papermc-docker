FROM ghcr.io/zekrotja/minebase:jdk-21

COPY scripts/ scripts/

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
