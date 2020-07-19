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
fi

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

eval $(minikube docker-env)

docker build -t nginx-image nginx
kubectl apply -f nginx.yaml 
kubectl apply -f loadbalancer.yaml
minikube service nginx-service

echo -n "Press a key to continue"
read hop
kubectl delete service nginx-service 
kubectl delete service loadbalancer
kubectl delete deployment nginx-deployment
