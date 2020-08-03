#!/bin/sh

sleep 10

MYSQL="mysql -h mysql -u root"

# init database

$MYSQL -e "grant all privileges on */* to 'root'@'%';"
$MYSQL -e 'flush privileges;'
$MYSQL -e 'drop database if exists wordpress;'
$MYSQL -e 'CREATE DATABASE wordpress;'
$MYSQL wordpress < /wordpressconf.sql
