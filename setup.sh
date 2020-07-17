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
    if ! minikube start --vm-driver=docker \
        --bootstrapper=kubeadm # allow telegraf to query metrics
    then
        echo Cannot start minikube!
        exit 1
    fi
    minikube addons enable metrics-server
    minikube addons enable ingress
fi

eval $(minikube docker-env)
docker build -t nginx-deployment nginx
kubectl apply -f nginx.yaml
kubectl expose deployment nginx-deployment --type=LoadBalancer --port=8080 #--port=443
minikube service nginx-deployment