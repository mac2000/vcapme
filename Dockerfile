FROM jwilder/nginx-proxy:alpine

COPY ./certs/vcap.me.crt /etc/nginx/certs/vcap.me.crt
COPY ./certs/vcap.me.key /etc/nginx/certs/vcap.me.key