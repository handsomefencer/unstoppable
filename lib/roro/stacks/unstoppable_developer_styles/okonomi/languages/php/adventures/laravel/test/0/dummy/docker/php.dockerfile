FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN apk add --update autoconf \
  build-base \
  freetype-dev \
  imagemagick6 \
  libjpeg-turbo-dev \
  libpng-dev \
  libpq \
  libzip-dev \
  pkgconfig \
  zlib-dev \
  zlib

RUN apk add --update \
  postgresql-dev
#RUN apk add --update \
#  postgresql-dev \
#  sqlite-dev


RUN pecl install -o -f redis

RUN docker-php-ext-configure gd
RUN docker-php-ext-install bcmath \
  exif \
  pcntl  \
  sockets \
  zip

RUN docker-php-ext-install pgsql \
  pdo_pgsql

# RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-enable redis

RUN link /usr/local/bin/php /usr/bin/php

RUN echo "php_admin_value[memory_limit] = 2G" >> /usr/local/etc/php-fpm.d/www.conf
RUN echo "memory_limit=2G" >> /usr/local/etc/php/php.ini
