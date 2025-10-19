FROM serversideup/php:8.4.4-fpm-nginx-alpine AS base
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
RUN apk add --no-cache --virtual .build-deps unzip curl \
 && apk add --no-cache mariadb-client nodejs npm \
 && install-php-extensions bcmath gd exif intl uv opentelemetry zlib ffi protobuf imagick vips \
 && curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip -q awscliv2.zip \
 && ./aws/install \
 && rm -rf aws awscliv2.zip \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/local/share/.cache

RUN docker-php-serversideup-dep-install-alpine git

# Set writable caches for www-data
ENV NPM_CONFIG_CACHE=/var/www/.npm
RUN mkdir -p /var/www/.npm && chown -R www-data:www-data /var/www/.npm

USER www-data
