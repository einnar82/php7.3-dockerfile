FROM php:7.3

# Install dependencies
RUN apt-get update && \
    apt-get install -y git \
    libzip-dev \
    zip \
    libjpeg-dev \
    libpng-dev \
    libpq-dev \
    sqlite3

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql pdo_pgsql mbstring exif pcntl zip
RUN docker-php-ext-configure zip --with-libzip --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install gd
RUN docker-php-ext-configure gd --with-gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel Envoy
RUN composer global require "laravel/envoy=~1.6"
