#!/bin/bash


HOSTNR=$(echo $HOSTNAME | tr -d "A-Za-z-")
PRIO=$[100 - $HOSTNR]
START=0

if [ "$HOSTNR" == "01" ] ; then
  PRIO=200
  START=1
elif [ "$HOSTNR" == "02" ] ; then
  PRIO=150
  START=1
elif [ "$HOSTNR" == "03" ] ; then
  PRIO=100
  START=1
fi

if [ "$START" == "0" ] ; then
docker kill keepalived-ipv6
docker kill keepalived-8
else
modprobe ip_vs

docker kill keepalived-8
docker run --rm -d --name keepalived-8 \
  --cap-add=NET_ADMIN --net=host \
  -e KEEPALIVED_UNICAST_PEERS="#PYTHON2BASH:['10.40.8.11','10.40.8.12','10.40.8.13']" \
  -e KEEPALIVED_VIRTUAL_IPS=10.40.8.10 \
  -e KEEPALIVED_INTERFACE=ens192 \
  -e KEEPALIVED_PASSWORD=ens192 \
  -e KEEPALIVED_ROUTER_ID=8 \
  -e KEEPALIVED_PRIORITY=$PRIO \
  -v /var/run/docker.sock:/var/run/docker.sock \
  styliteag/docker-keepalived-with-labels:latest

docker kill keepalived-ipv6
docker run --rm -d --name keepalived-ipv6 \
  --cap-add=NET_ADMIN --net=host \
  -e KEEPALIVED_UNICAST_PEERS="#PYTHON2BASH:['2001:DB8:4008:d0ce::11','2001:DB8:4008:d0ce::12',2001:DB8:4008:d0ce::13']" \
  -e KEEPALIVED_VIRTUAL_IPS=2001:DB8:4008::10 \
  -e KEEPALIVED_INTERFACE=ens256 \
  -e KEEPALIVED_PASSWORD=ens256v6 \
  -e KEEPALIVED_ROUTER_ID=8 \
  -e KEEPALIVED_PRIORITY=$PRIO \
  -v /var/run/docker.sock:/var/run/docker.sock \
  styliteag/docker-keepalived-with-labels:latest
fi
