#!/bin/bash
telegraf &
chown -R nobody:nogroup /srv/ftp
echo "FUCK FT_SERVICES" > /srv/ftp/fuck_ft_services
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
