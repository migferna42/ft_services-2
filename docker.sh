#!/bin/bash

NAME=ftps
DIR=srcs/$NAME

docker rm -f $NAME || echo "";
docker build $DIR -t $NAME
docker run --name $NAME -p 21:21 -p 21000:21000 -it $NAME
