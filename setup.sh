#!/bin/bash

if [[ "hop" == "hop" ]]
then
  echo "starting..."
else
  echo "launch with ./setup.sh or bash setup.sh"
  exit 1
fi

# Ensure minikube is launched, adapt stuff for linux and mac
if [[ $OSTYPE == "darwin"* ]]
then
    brew uninstall -f docker docker-compose docker-machine || true
    if ! which docker >/dev/null 2>&1 || ! which minikube >/dev/null 2>&1
    then
        echo Please install Docker and Minikube
        exit 1
    fi
    docker_destination="/goinfre/$USER/docker"
    minikube_destination="/goinfre/$USER/minikube"
    if [ ! -d $docker_destination ]
    then
      pkill Docker
      rm -rf ~/Library/Containers/com.docker.docker ~/.docker
      mkdir -p $docker_destination/{com.docker.docker,.docker}
      ln -sf $docker_destination/com.docker.docker ~/Library/Containers/com.docker.docker
      ln -sf $docker_destination/.docker ~/.docker
    fi
    open -a Docker
    export MINIKUBE_HOME=$minikube_destination
elif [[ $OSTYPE != "linux-gnu"* ]]
then
    echo Unsupported OS!
    exit 1
fi

if ! minikube status >/dev/null 2>&1
then
    if [[ $OSTYPE == "darwin"* ]]
    then
        if ! minikube start --vm-driver=virtualbox --cpus 3 --disk-size=30000mb --memory=3000mb --bootstrapper=kubeadm
        then
            echo Cannot start minikube!
            exit 1
        fi
    else
      service docker restart
      if ! minikube start --vm-driver=docker --bootstrapper=kubeadm
        then
            echo Cannot start minikube!
            exit 1
        fi
    fi
    minikube addons enable metrics-server
    #kubectl edit configmap -n kube-system kube-proxy
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
fi

kubectl delete deployments --all
kubectl delete svc --all

if [[ $OSTYPE == "darwin"* ]]
then
    ftps_ip='192.168.99.110'
    grafana_ip='192.168.99.111'
    nginx_ip='192.168.99.112'
    phpmyadmin_ip='192.168.99.113'
    wordpress_ip='192.168.99.114'
else
    ftps_ip='172.17.0.2'
    grafana_ip='172.17.0.3'
    nginx_ip='172.17.0.4'
    phpmyadmin_ip='172.17.0.5'
    wordpress_ip='172.17.0.6'
fi

eval $(minikube docker-env);

IP=`kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p`;

sed -i.backup "s/metallb_ips/$ftps_ip-$wordpress_ip/g" srcs/metallb.yaml
sed -i.backup "s/grafana_ip/$grafana_ip/g" srcs/nginx/nginx.conf
sed -i.trash "s/nginx_ip/$nginx_ip/g" srcs/nginx/nginx.conf
sed -i.trash "s/phpmyadmin_ip/$phpmyadmin_ip/g" srcs/nginx/nginx.conf
sed -i.trash "s/wordpress_ip/$wordpress_ip/g" srcs/nginx/nginx.conf
sed -i.backup "s/LB_wordpress_ip/$wordpress_ip/g" srcs/wordpress/wordpressconf.sql

docker build -t mysql-image srcs/mysql
docker build -t cleaner-image srcs/cleaner
docker build -t nginx-image srcs/nginx
docker build -t phpmyadmin-image srcs/phpmyadmin
docker build -t wordpress-image srcs/wordpress
docker build -t grafana-image srcs/grafana
docker build -t influxdb-image srcs/influxdb
docker build -t ftps-image srcs/ftps
kubectl apply -k srcs

mv srcs/metallb.yaml.backup srcs/metallb.yaml
mv srcs/nginx/nginx.conf.backup srcs/nginx/nginx.conf
mv srcs/wordpress/wordpressconf.sql.backup srcs/wordpress/wordpressconf.sql
rm -rf srcs/nginx/*.trash*

echo "index : http://$nginx_ip"
echo "ssh connection : ssh www@$nginx_ip"
echo "ftp connection (linux only): lftp $ftps_ip"

minikube dashboard
