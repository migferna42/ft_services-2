FROM alpine

#ftps server setup
RUN apk update \
&& apk add bash vsftpd \
&& rm -rf /var/cache/apk/* \
&& mkdir /srv/ftp
COPY vsftpd.conf /etc/vsftpd/

#telegraf setup
RUN mkdir /etc/telegraf \
&& wget https://dl.influxdata.com/telegraf/releases/telegraf-1.13.3-static_linux_amd64.tar.gz \
&& tar -C . -xzf telegraf-1.13.3-static_linux_amd64.tar.gz \
&& chmod 775 telegraf/* \
&& cp telegraf/telegraf /usr/bin/ \
&& rm -rf /var/cache/apk/*
COPY telegraf.conf /etc/telegraf/telegraf.conf

COPY start.sh /

EXPOSE 21 21000
CMD bash /start.sh
