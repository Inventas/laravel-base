FROM serversideup/php:8.3-fpm-nginx-alpine AS base

USER root

#RUN apk update && apk add mariadb-client
#RUN install-php-extensions bcmath gd exif intl uv
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#    unzip awscliv2.zip && \
#    ./aws/install
#
#RUN docker-php-serversideup-dep-install-alpine git

USER www-data