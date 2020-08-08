FROM alpine

WORKDIR /usr/share/grafana

RUN apk update && apk add bash curl wget grafana \
--repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
&& rm -rf /var/cache/apk/*

COPY datasources/datasource.yaml /usr/share/grafana/conf/provisioning/datasources/

RUN mkdir /usr/share/grafana/conf/provisioning/dashboards/mine
COPY dashboards/mine/*.json /usr/share/grafana/conf/provisioning/dashboards/mine/
COPY dashboards/sample.yaml /usr/share/grafana/conf/provisioning/dashboards/

EXPOSE 3000

CMD /usr/sbin/grafana-server web
