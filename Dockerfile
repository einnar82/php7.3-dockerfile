FROM php:7.3

# Composer arguments
# Incase you want to change composer directory and filename
ARG COMPOSER_DIR=/usr/local/bin
ARG COMPOSER_FILENAME=composer

# Envoy version
# Incase you want to change envoy version during build
# `docker build -t ranniephp73 --build-arg ENVOY_VERSION=~1`
# Above cmd will install envoy on ~1
ARG ENVOY_VERSION=~1.6

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    libzip-dev \
    zip \
    libjpeg-dev \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    sqlite3

# Clear cache
RUN apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# Install extensions
# Make it readable and arrange from A-Z
RUN docker-php-ext-install \
    bcmath \
    exif \
    gd \
    mbstring \
    pdo_mysql \
    pdo_pgsql \
    pcntl \
    soap \
    zip

# Configure gd first
RUN docker-php-ext-configure gd \
    --with-gd \
    --with-jpeg-dir=/usr/include/ \
    --with-png-dir=/usr/include/

# Configure zip first
RUN docker-php-ext-configure zip \
    --with-libzip


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=${COMPOSER_DIR} \
    --filename=${COMPOSER_FILENAME}

# Install Laravel Envoy
RUN ${COMPOSER_DIR}/${COMPOSER_FILENAME} global require "laravel/envoy=${ENVOY_VERSION}"
