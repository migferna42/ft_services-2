FROM alpine
ARG IP
ENV ENV_IP=$IP
RUN apk update
RUN apk add openrc --no-cache
RUN apk add pure-ftpd --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache
RUN { echo "anon"; echo "anon"; } | adduser anon
EXPOSE 21 21000
CMD pure-ftpd -p 21000:21000 -P $ENV_IP
