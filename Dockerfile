FROM serversideup/php:8.5.9-fpm-nginx-alpine@sha256:638a31d2201022b61605fd423b86ccaed20c12732f6aba4870f4c3ff1d8e57da AS base
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

RUN php -r 'exit(PHP_VERSION === "8.5.9" ? 0 : 1);' \
 && aws --version \
 && node --version \
 && npm --version

RUN docker-php-serversideup-dep-install-alpine git

# Set writable caches for www-data
ENV NPM_CONFIG_CACHE=/var/www/.npm
RUN mkdir -p /var/www/.npm && chown -R www-data:www-data /var/www/.npm

USER www-data
