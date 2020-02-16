#!/bin/bash

# install docker and minikube if necessary
if ! which docker >/dev/null 2>&1 ||
    ! which minikube >/dev/null 2>&1
then
    echo Please install Docker and Minikube
    exit 1
fi

# Ensure minikube is launched
if ! minikube status >/dev/null 2>&1
then
    echo Minikube is not started! Starting now...
    if ! minikube start --vm-driver=virtualbox \
        --cpus 3 --disk-size=30000mb --memory=3000mb \
        --bootstrapper=kubeadm # allow telegraf to query metrics
    then
        echo Cannot start minikube!
        exit 1
    fi
    minikube addons enable metrics-server
    minikube addons enable ingress
fi