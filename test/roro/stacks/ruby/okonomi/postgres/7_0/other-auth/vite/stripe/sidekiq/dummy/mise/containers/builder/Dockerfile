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
  postgresql-dev

FROM builder AS generator

WORKDIR /app

RUN gem install bundler:2.4.13
RUN echo -e "source 'https://rubygems.org'\ngem 'rails', '~> 7.0.6'" > Gemfile

RUN bundle install -j4 --retry 3

## Use Rails to generate a new app. We'll configure it later.

RUN bundle exec rails new . \
  --database=postgresql \
  --css=tailwind \
  --javascript=importmap


RUN bundle add vite_rails 
RUN bundle exec vite install

RUN rm config/master.key

FROM scratch AS export-stage

## Copy the generated files onto the host.
COPY --from=generator ./app/ .