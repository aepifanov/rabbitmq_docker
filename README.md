=====================================
Docker container builder for RabbitMQ
=====================================

#Install
  1. Install dnsmasq for the resolving hostname of containers:
  
      `make dnsmasq_install`
  
  2. Build the docker image with RabbitMQ. The basis is the phusion/baseimage:
  
      `make all`

Using
-----
  1. Create test RabbitMQ cluster (3 nodes: rmq1, rmq2, rmq3):
  
      `make env`
  
  2. Remove RabbitMQ cluster:
  
      `make env_rm`
  
