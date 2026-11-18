FROM node:24.22.0-alpine3.24@sha256:44fce696f38ba8c987c4db89954051000bbd05ffd8d8659ba15ed4a8602e937f AS node

FROM serversideup/php:8.5.12-fpm-nginx-alpine-v5.1.4@sha256:d3f19536bee1e06f635f7fc1f561964b14e89c72db0b5f24602e81a3935232c5 AS base
LABEL org.opencontainers.image.source="https://github.com/inventas/laravel-base"

USER root

# Add libvips + deps
RUN apk add --no-cache \
        vips \
        vips-dev \
        fftw \
        glib \
        libexif \
        lcms2 \
        libjpeg-turbo \
        libpng \
        libwebp \
        libheif \
        librsvg \
        orc \
        tiff \
        zlib

# PHP extensions and utilities
RUN apk add --no-cache aws-cli mariadb-client libstdc++ \
 && install-php-extensions bcmath gd exif intl uv opentelemetry zlib ffi protobuf imagick vips sockets \
 && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/local/share/.cache

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
 && ln -s ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN php -r 'exit(PHP_VERSION === "8.5.12" ? 0 : 1);' \
 && aws --version \
 && node --version \
 && npm --version

RUN docker-php-serversideup-dep-install-alpine git

# Set writable caches for www-data
ENV NPM_CONFIG_CACHE=/var/www/.npm
RUN mkdir -p /var/www/.npm && chown -R www-data:www-data /var/www/.npm

USER www-data
