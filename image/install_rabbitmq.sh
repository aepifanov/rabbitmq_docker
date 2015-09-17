#!/bin/bash


# System update
apt-get update
apt-get dist-upgrade

# Install pacemaker
apt-get install -y --no-install-recommends rabbitmq-server wget
cp -f /build/my_init/rabbitmq /etc/my_init.d/
cp -f /build/config/enabled_plugins /etc/rabbitmq/
cp -f /build/config/rabbitmq.config /etc/rabbitmq/

# Configuring SSH
SSH_PUB_KEY=/build/ssh/id_rsa.pub

rm -f /etc/service/sshd/down
/etc/my_init.d/00_regen_ssh_host_keys.sh
cat ${SSH_PUB_KEY} >> /root/.ssh/authorized_keys
ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ""
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Don't like it, just remove
rm -rf /etc/service/syslog-forwarder
