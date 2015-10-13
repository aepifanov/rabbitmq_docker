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
for NODE in ${NODES}; do
    echo -e "\n### Configuring RabbitMQ cluster on ${NODE}"
    # Stop and clear RabbitMQ
    ssh -q $USER@$NODE rabbitmqctl stop_app
    ssh -q $USER@$NODE rabbitmqctl reset
    ssh -q $USER@$NODE rabbitmqctl stop
    sleep 2
    # Add cluster setting to the config
    ssh -q $USER@$NODE exec "sed -i \"s/{rabbit, \[/{rabbit, \[\n    {cluster_nodes, {[${LIST_NODES}], disc}},/g\" ${RMQ_CONF}"
    # All cluster nodes have to have the same cookie
    ssh -q $USER@$NODE exec "echo "LSOPFHUMRHGYDZFZIAZV" > /var/lib/rabbitmq/.erlang.cookie"
    # Start service with the new configuration
    ssh -q $USER@$NODE service rabbitmq-server start
done

