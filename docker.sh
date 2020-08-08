#!/bin/bash

NAME=telegraf
DIR=srcs/$NAME

docker rm -f $NAME || echo "";
docker build $DIR -t $NAME
docker run --name $NAME  -it $NAME
