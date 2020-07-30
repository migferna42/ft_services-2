#!/bin/bash

EXTERN_IP=127.0.0.1
DIR=srcs/phpmyadmin

#find srcs -type f -exec sed -i -e "s/hop-sed/$EXTERN_IP/g" {} \;
#rm -f srcs/*-e srcs/*/*-e

docker rm -f hopla
docker build $DIR -t hopla
docker run --name hopla -it hopla

#find srcs -type f -exec sed -i -e "s/$EXTERN_IP/hop-sed/g" {} \;
#rm -f srcs/*-e srcs/*/*-e
