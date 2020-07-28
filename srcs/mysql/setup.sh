#!/bin/bash

mysql
sleep 3
echo "grant all privileges on *.* to root@localhost;" | mysql -u root
echo "update mysql.user set plugin = 'mysql_native_password' where user = 'root';" | mysql -u root
echo "flush privileges;" | mysql -u root

pkill mysql
mysql
sleep 3
echo "create database wordpress;" | mysql -u root
echo "grant all privileges on */* to root@localhost;" | mysql -u root
echo "flush privileges;" | mysql -u root
mysql wordpress < /wordpressconf.sql
