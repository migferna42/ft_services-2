#!/bin/bash

EXTERN_IP=127.0.0.1
DIR=srcs/nginx

find srcs -type f -exec sed -i -e "s/hop-sed/$EXTERN_IP/g" {} \;
rm -f srcs/*-e srcs/*/*-e

docker build $DIR -t hop
docker run -p 80:80 -p 443:443 -it hop

find srcs -type f -exec sed -i -e "s/$EXTERN_IP/hop-sed/g" {} \;
rm -f srcs/*-e srcs/*/*-e
sed -i -e "s/listen = hop-sed:9000\/listen = hop-sed:9000/listen = 127.0.0.1:9000\/listen = hop-sed:9000/g" srcs/nginx/dockerfile
rm -f srcs/*-e srcs/*/*-e
