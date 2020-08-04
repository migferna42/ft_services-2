#!/bin/bash

#EXTERN_IP=127.0.0.1
NAME=phpmyadmin
DIR=srcs/$NAME
# EXTERN_IP=127.0.0.1

# find srcs -type f -exec sed -i -e "s/hop-sed/$EXTERN_IP/g" {} \;
# rm -f srcs/*-e srcs/*/*-e

docker rm -f $NAME || echo "";
docker build $DIR -t $NAME
docker run --name $NAME -p 80:5000 -it $NAME

# find srcs -type f -exec sed -i -e "s/$EXTERN_IP/hop-sed/g" {} \;
# rm -f srcs/*-e srcs/*/*-e
