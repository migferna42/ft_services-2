FROM alpine
RUN apk update && apk add bash influxdb \
&& rm -rf /var/cache/apk/*
EXPOSE 8086
CMD influxd run -config /etc/influxdb.conf
