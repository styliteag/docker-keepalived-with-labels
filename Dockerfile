FROM osixia/keepalived:latest
LABEL maintainer="Wim Bonis wb@stylite.de"

RUN apk --no-cache add docker

ADD notify.sh /container/service/keepalived/assets/notify.sh

RUN date > /version.txt
RUN env > /buildenv.txt
