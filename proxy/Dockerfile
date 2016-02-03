FROM nginx

RUN apt-get update && apt-get install -yqq curl vim
COPY certs/ /etc/certs
COPY conf.d/* /etc/nginx/conf.d/