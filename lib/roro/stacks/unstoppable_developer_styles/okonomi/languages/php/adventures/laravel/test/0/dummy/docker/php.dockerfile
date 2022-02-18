FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN apk add --update sqlite-dev zlib-dev zlib libpng-dev libzip-dev freetype-dev libjpeg-turbo-dev libpq postgresql-dev pkgconfig imagemagick6 autoconf
RUN docker-php-ext-configure gd
RUN docker-php-ext-install zip pcntl pdo pdo_mysql gd exif sockets pgsql bcmath pdo_pgsql exif
RUN docker-php-ext-enable pdo_pgsql exif
RUN apk add --update autoconf build-base
RUN pecl install -o -f redis
RUN docker-php-ext-enable redis
RUN link /usr/local/bin/php /usr/bin/php

RUN echo "php_admin_value[memory_limit] = 2G" >> /usr/local/etc/php-fpm.d/www.conf
RUN echo "memory_limit=2G" >> /usr/local/etc/php/php.ini
