# syntax=docker/dockerfile:1

FROM composer as builder
  
WORKDIR /app/

RUN composer create-project laravel/laravel \
  unstoppable_app

FROM scratch AS export-stage

COPY --from=builder ./app/unstoppable_app .