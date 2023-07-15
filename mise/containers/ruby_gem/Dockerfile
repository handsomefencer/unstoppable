# syntax=docker/dockerfile:1
FROM ruby:3.2.1-alpine AS base

RUN apk add --no-cache \
    file \
    sudo

RUN apk add --no-cache \
    docker 

FROM base AS builder

RUN apk add --no-cache \
    build-base \  
    git 

RUN gem install bundler:2.4.13

FROM builder AS development


WORKDIR /usr/src

RUN gem install bundler:2.4.13

COPY . .

RUN bundle install -j4 --retry 3

RUN gem build roro.gemspec
RUN rake install

FROM builder AS stripper

WORKDIR /usr/src

COPY . .

RUN bundle install -j4 --retry 3

RUN gem build roro.gemspec
RUN rake install

FROM builder AS production

RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

COPY --from=stripper --chown=app:app /usr/local/bundle/ /usr/local/bundle/

WORKDIR /artifact