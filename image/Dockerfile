FROM phusion/baseimage:latest

MAINTAINER Andrey Epifanov <andrey@epifanov.net>

ENV HOME /mnt/baseimage/rabbitmq/image
ADD . /build

RUN /build/install_rabbitmq.sh && \
    /build/cleanup.sh

CMD ["/sbin/my_init"]
