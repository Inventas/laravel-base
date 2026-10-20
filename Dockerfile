FROM serversideup/php:8.5.11-fpm-nginx-alpine@sha256:261e19b886cf5bbb1c3693b01a451ad73374b3834cd3d78d30030f44c1d0a19e AS base
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
RUN apk add --no-cache aws-cli mariadb-client nodejs npm \
 && install-php-extensions bcmath gd exif intl uv opentelemetry zlib ffi protobuf imagick vips sockets \
 && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/local/share/.cache

RUN php -r 'exit(PHP_VERSION === "8.5.11" ? 0 : 1);' \
 && aws --version \
 && node --version \
 && npm --version

RUN docker-php-serversideup-dep-install-alpine git

# Set writable caches for www-data
ENV NPM_CONFIG_CACHE=/var/www/.npm
RUN mkdir -p /var/www/.npm && chown -R www-data:www-data /var/www/.npm

USER www-data
