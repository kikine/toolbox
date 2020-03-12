#!/bin/bash

export HTTP_PROXY="http://proxy-host:proxy-port"
export HTTPS_PROXY="http://proxy-host:proxy-port"
export NO_PROXY="localhost,127.0.0.1,10.96.0.0/12,192.168.99.100,192.168.99.0/24,192.168.39.0/24,.my.com"

minikube start \
    --docker-env HTTP_PROXY=$HTTP_PROXY \
    --docker-env HTTPS_PROXY=$HTTPS_PROXY \
    --docker-env NO_PROXY=$NO_PROXY \
    --vm-driver=virtualbox \
    --disk-size='50000mb' \
    --memory='12000mb' \
    --cpus=4
