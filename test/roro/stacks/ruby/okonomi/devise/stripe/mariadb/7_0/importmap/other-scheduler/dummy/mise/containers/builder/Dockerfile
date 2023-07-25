# syntax=docker/dockerfile:1

FROM ruby:3.2.2-alpine AS base

RUN apk add --update --no-cache \
  file \
  gcompat \
  tzdata

FROM base AS builder

RUN apk add --update --no-cache \
  build-base \
  git \
  nodejs \
  npm \
  vips-dev \
  yarn 

RUN apk add --update --no-cache \
  mariadb-dev

FROM builder AS generator

WORKDIR /app

RUN gem install bundler:2.4.13
RUN echo -e "source 'https://rubygems.org'\ngem 'rails', '~> 7.0.6'" > Gemfile

RUN bundle install -j4 --retry 3

## Use Rails to generate a new app. We'll configure it later.

RUN bundle exec rails new . \
  --database=mysql \
  --css=tailwind \
  --javascript=importmap


RUN bundle add devise
RUN bundle add letter_opener -g development
RUN bin/rails generate devise:install
RUN bin/rails generate devise User
RUN bin/rails generate devise:views
RUN bundle add pay
RUN bundle add stripe
RUN bin/rails pay:install:migrations
RUN bin/rails generate pay:views
RUN bin/rails generate pay:email_views

RUN rm config/master.key

FROM scratch AS export-stage

## Copy the generated files onto the host.
COPY --from=generator ./app/ .