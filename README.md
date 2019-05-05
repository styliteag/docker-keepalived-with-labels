# styliteag/docker-keepalived-with-labels

This image uses https://github.com/osixia/docker-keepalived 
I adds helper script (notify.sh) which will update the Label of the host 

start-node-sh is a example how to start a keepalive on 3 nodes

The node where the keepalive is the MASTER, will have the KEEPALIVE-10.40.8.10=MASTER and KEEPALIVE-2001:DB8:4008:d0ce::10=MASTER

[hub]: https://hub.docker.com/r/sityliteag/docker-keepalived-with-labels

**A docker image to run Keepalived.**
> [keepalived.org](http://keepalived.org/)

This image require the kernel module ip_vs loaded on the host (`modprobe ip_vs`) and need to be run with : --cap-add=NET_ADMIN --net=host

    docker run --cap-add=NET_ADMIN --net=host -d styliteag/docker-keepalived-with-labels

## Beginner Guide

### Use your own Keepalived config
This image comes with a keepalived config file that can be easily customized via environment variables for a quick bootstrap,
but setting your own keepalived.conf is possible. 2 options:

- Link your config file at run time to `/container/service/keepalived/assets/keepalived.conf` :

      docker run --volume /data/my-keepalived.conf:/container/service/keepalived/assets/keepalived.conf --detach styliteag/docker-keepalived-with-labels

- Add your config file by extending or cloning this image, please refer to the [Advanced User Guide](#advanced-user-guide)

### Fix docker mounted file problems

You may have some problems with mounted files on some systems. The startup script try to make some file adjustment and fix files owner and permissions, this can result in multiple errors. See [Docker documentation](https://docs.docker.com/v1.4/userguide/dockervolumes/#mount-a-host-file-as-a-data-volume).

To fix that run the container with `--copy-service` argument :

		docker run [your options] styliteag/docker-keepalived-with-labels --copy-service

### Debug

The container default log level is **info**.
Available levels are: `none`, `error`, `warning`, `info`, `debug` and `trace`.

Example command to run the container in `debug` mode:

	docker run --detach styliteag/docker-keepalived-with-labels --loglevel debug

See all command line options:

	docker run styliteag/docker-keepalived-with-labels --help


## Environment Variables

Environment variables defaults are set in **image/environment/default.yaml**

See how to [set your own environment variables](#set-your-own-environment-variables)


- **KEEPALIVED_INTERFACE**: Keepalived network interface. Defaults to `eth0`
- **KEEPALIVED_PASSWORD**: Keepalived password. Defaults to `d0cker`
- **KEEPALIVED_PRIORITY** Keepalived node priority. Defaults to `150`
- **KEEPALIVED_ROUTER_ID** Keepalived virtual router ID. Defaults to `51`

- **KEEPALIVED_UNICAST_PEERS** Keepalived unicast peers. Defaults to :
      - 192.168.1.10
      - 192.168.1.11

  If you want to set this variable at docker run command add the tag `#PYTHON2BASH:` and convert the yaml in python:

      docker run --env KEEPALIVED_UNICAST_PEERS="#PYTHON2BASH:['192.168.1.10', '192.168.1.11']" --detach styliteag/docker-keepalived-with-labels

  To convert yaml to python online : http://yaml-online-parser.appspot.com/


- **KEEPALIVED_VIRTUAL_IPS** Keepalived virtual IPs. Defaults to :

      - 192.168.1.231
      - 192.168.1.232

  If you want to set this variable at docker run command convert the yaml in python, see above.

- **KEEPALIVED_NOTIFY** Script to execute when node state change. Defaults to `/container/service/keepalived/assets/notify.sh`

- **KEEPALIVED_COMMAND_LINE_ARGUMENTS** Keepalived command line arguments; Defaults to `--log-detail --dump-conf`

- **KEEPALIVED_STATE** The starting state of keepalived; it can either be MASTER or BACKUP.

### Set your own environment variables

#### Use command line argument
Environment variables can be set by adding the --env argument in the command line, for example:

    docker run --env KEEPALIVED_INTERFACE="eno1" --env KEEPALIVED_PASSWORD="password!" \
    --env KEEPALIVED_PRIORITY="100" --detach styliteag/docker-keepalived-with-labels


#### Link environment file

For example if your environment file is in :  /data/environment/my-env.yaml

	docker run --volume /data/environment/my-env.yaml:/container/environment/01-custom/env.yaml \
	--detach styliteag/docker-keepalived-with-labels

Take care to link your environment file to `/container/environment/XX-somedir` (with XX < 99 so they will be processed before default environment files) and not  directly to `/container/environment` because this directory contains predefined baseimage environment files to fix container environment (INITRD, LANG, LANGUAGE and LC_CTYPE).

## Advanced User Guide

### Under the hood: osixia/light-baseimage

This image is based on osixia/light-baseimage.
More info: https://github.com/osixia/docker-light-baseimage

## Changelog

Please refer to: [CHANGELOG.md](CHANGELOG.md)
