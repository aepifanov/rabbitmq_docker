#!/bin/bash

USER=root
NODES="$@"
RMQ_CONF="/etc/rabbitmq/rabbitmq.config"

for NODE in ${NODES}; do
    if [ -z "${LIST_NODES}" ] ; then
        LIST_NODES="'rabbit@${NODE}'"
    else
        LIST_NODES="${LIST_NODES}, 'rabbit@${NODE}'"
    fi
done

# Add all nodes to the cluster and restart the service
for IP in ${NODES}; do
    # Stop and clear RabbitMQ
    ssh $USER@$IP rabbitmqctl stop_app
    ssh $USER@$IP rabbitmqctl reset
    ssh $USER@$IP rabbitmqctl stop
    sleep 2
    # Add cluster setting to the config
    ssh $USER@$IP exec "sed -i \"s/{rabbit, \[/{rabbit, \[\n    {cluster_nodes, {[${LIST_NODES}], disc}},/g\" ${RMQ_CONF}"
    # All cluster nodes have to have the same cookie
    ssh $USER@$IP exec "echo "LSOPFHUMRHGYDZFZIAZV" > /var/lib/rabbitmq/.erlang.cookie"
    # Start service with the new configuration
    ssh $USER@$IP service rabbitmq-server start
done

