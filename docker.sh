#!/bin/bash

EXTERN_IP=127.0.0.1
NAME=wordpress
DIR=srcs/$NAME

#find srcs -type f -exec sed -i -e "s/hop-sed/$EXTERN_IP/g" {} \;
#rm -f srcs/*-e srcs/*/*-e

docker rm -f $NAME
docker build $DIR -t $NAME
docker run --name $NAME -p 5050:5050 -it $NAME

#find srcs -type f -exec sed -i -e "s/$EXTERN_IP/hop-sed/g" {} \;
#rm -f srcs/*-e srcs/*/*-e
