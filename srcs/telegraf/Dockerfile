FROM alpine
RUN mkdir /etc/telegraf \
&& wget https://dl.influxdata.com/telegraf/releases/telegraf-1.13.3-static_linux_amd64.tar.gz \
&& tar -C . -xzf telegraf-1.13.3-static_linux_amd64.tar.gz \
&& chmod 775 telegraf/* \
&& cp telegraf/telegraf /usr/bin/ \
&& rm -rf /var/cache/apk/*
COPY telegraf.conf /etc/telegraf/telegraf.conf
EXPOSE 4999
CMD /usr/bin/telegraf
