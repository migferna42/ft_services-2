FROM alpine
ARG IP
ENV MINIKUBE_IP=${IP}

RUN mkdir /etc/telegraf && \
    wget https://dl.influxdata.com/telegraf/releases/telegraf-1.13.3-static_linux_amd64.tar.gz && \
    tar -C . -xzf telegraf-1.13.3-static_linux_amd64.tar.gz && \
    chmod +x telegraf/* && \
    cp telegraf/telegraf /usr/bin/ && \
    rm -rf *.tar.gz* telegraf/ && \
    rm -rf /var/cache/apk/*

RUN apk add curl nano gettext
COPY telegraf.conf /etc/telegraf/telegraf.conf
COPY start.sh .

RUN chmod +x start.sh

EXPOSE 4999

CMD ./start.sh
