# syntax=docker/dockerfile:1

FROM php:7.4-fpm-alpine as builder

WORKDIR /app/

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer create-project laravel/laravel \
  blog

FROM scratch AS export-stage

COPY --from=builder ./app/blog .