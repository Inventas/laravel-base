FROM php:8.2-fpm as api

WORKDIR /usr/src

ARG NODE_VERSION=20

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && mkdir -p /etc/apt/keyrings && apt-get install -y \
    git \
    gnupg \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libjpeg-dev jpegoptim optipng pngquant gifsicle libjpeg62-turbo-dev cmake libfreetype6-dev libfontconfig1-dev xclip \
    libc6 \
    zip \
    unzip \
    supervisor \
    default-mysql-client

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x nodistro main" > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs && npm install -g pnpm

ENV COMPOSER_ALLOW_SUPERUSER=1

# Cleans the cache memory of downloaded package files.
# Removes the lists of available packages and their dependencies.
# They're automatically regenerated the next time apt-get update is run.
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl filter fileinfo \
    && pecl install redis

