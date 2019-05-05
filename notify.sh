#!/bin/bash

# for ANY state transition.
           # "notify" script is called AFTER the notify_* script(s) and
           # is executed with 4 additional arguments after the configured
           # arguments provided by Keepalived:
           #   $(n-3) = "GROUP"|"INSTANCE"
           #   $(n-2) = name of the group or instance
           #   $(n-1) = target state of transition (stop only applies to instances)
           #            ("MASTER"|"BACKUP"|"FAULT"|"STOP")
           #   $(n)   = priority value
           #   $(n-3) and $(n-1) are ALWAYS sent in uppercase, and the possible
           #
           # strings sent are the same ones listed above
           #   ("GROUP"/"INSTANCE", "MASTER"/"BACKUP"/"FAULT"/"STOP")
           # (note: STOP is only applicable to instances)
           #           notify <STRING>|<QUOTED-STRING> [username [groupname]]

#echo $0 $@ >> /tmp/notify.log

if [ -x /usr/bin/docker -a -r /var/run/docker.sock ] ; then
	docker node update --label-add KEEPALIVE-$KEEPALIVED_VIRTUAL_IPS=$3 $HOSTNAME
	docker node update --label-add KEEPALIVE-$KEEPALIVED_ROUTER_ID=$3 $HOSTNAME
fi