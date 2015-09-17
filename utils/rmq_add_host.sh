#!/bin/bash

NAME=${1:?"The first argument is name. Please specify."}

docker run -h ${NAME} --name ${NAME} --dns=172.17.42.1 -t -d aepifanov/rabbitmq  /sbin/my_init -- bash -l

./dnsmasq_update
