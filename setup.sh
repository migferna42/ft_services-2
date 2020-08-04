#!/bin/bash

# install docker and minikube if necessary
brew uninstall -f docker docker-compose docker-machine || true
if ! which docker >/dev/null 2>&1 ||
    ! which minikube >/dev/null 2>&1
then
    echo Please install Docker and Minikube
    exit 1
fi

docker_destination="/goinfre/$USER/docker"
minikube_destination="/goinfre/$USER/minikube"

# Create needed files in destination and make symlinks
if [ ! -d $docker_destination ]; then
	pkill Docker
	rm -rf ~/Library/Containers/com.docker.docker ~/.docker
	mkdir -p $docker_destination/{com.docker.docker,.docker}
	ln -sf $docker_destination/com.docker.docker ~/Library/Containers/com.docker.docker
	ln -sf $docker_destination/.docker ~/.docker
fi

# Start Docker for Mac
open -a Docker


export MINIKUBE_HOME=$minikube_destination

# Ensure minikube is launched
if ! minikube status >/dev/null 2>&1
then
    echo Minikube is not started! Starting now...
    if ! minikube start --driver=docker #--vm-driver=virtualbox --dns-proxy=false --dns-domain='cluster.local'
       # weird stuff # --bootstrapper=kubeadm # allow telegraf to query metrics
    then
        echo Cannot start minikube!
        exit 1
    fi
    minikube addons enable metrics-server
	kubectl edit configmap -n kube-system kube-proxy
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
fi

eval $(minikube docker-env)

EXTERN_IP=`kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p`;
find srcs -type f -exec sed -i -e "s/172.17.0.2/hop-sed/g" {} \;;
rm -f srcs/*-e srcs/*/*-e;
find srcs -type f -exec sed -i -e "s/hop-sed/$EXTERN_IP/g" {} \;
rm -f srcs/*-e srcs/*/*-e;

docker build -t mysql-image srcs/mysql
docker build -t cleaner-image srcs/cleaner
docker build -t nginx-image srcs/nginx
docker build -t phpmyadmin-image srcs/phpmyadmin
docker build -t wordpress-image srcs/wordpress
kubectl apply -k srcs

sleep 6 && open http://$EXTERN_IP
# minikube dashboard
echo "\nPress a key to kill and clean up"
read hop

minikube ssh


# clean up
kubectl delete -k srcs
find srcs -type f -exec sed -i -e "s/$EXTERN_IP/hop-sed/g" {} \;;
rm -f srcs/*-e srcs/*/*-e;
