#!/bin/sh

mv /wordpress/* /www && chmod -R 775 /www

# wordpress database creation
sleep 15
MYSQL="mysql -h mysql -u root"
$MYSQL -e "grant all privileges on */* to 'root'@'%';"
$MYSQL -e 'flush privileges;'
$MYSQL -e 'drop database if exists wordpress;'
$MYSQL -e 'CREATE DATABASE wordpress;'
$MYSQL wordpress < /wordpressconf.sql

# starting telegraf and php server
telegraf &
php -S 0.0.0.0:5050 -t /www
