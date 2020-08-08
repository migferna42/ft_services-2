#!/bin/bash

mkdir /www/wordpress /www/phpmyadmin /www/grafana && chmod 775 -R /www
nginx -g "daemon off;"
