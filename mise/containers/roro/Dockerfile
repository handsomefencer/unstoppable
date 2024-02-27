# syntax=docker/dockerfile:1
FROM ruby:3.2.2-alpine AS base

RUN apk add --no-cache \
    file \
    sudo

RUN apk add --no-cache \
    docker \
    docker-compose

FROM base AS builder

RUN apk add --no-cache \
    build-base \  
    git 

RUN gem install bundler:2.4.13


FROM builder AS development

WORKDIR /usr/src

COPY . .
RUN git config --global --add safe.directory /usr/src
RUN gem install bundler:2.4.13

COPY . .

RUN bundle install -j4 --retry 3

RUN git config --global --add safe.directory /usr/src

RUN gem build roro.gemspec
RUN rake install

WORKDIR /artifact

FROM builder AS stripper

WORKDIR /usr/src

COPY . .

RUN bundle install -j4 --retry 3

COPY . .

RUN gem build roro.gemspec
RUN rake install
RUN rm -rf /usr/local/bundle/cache
RUN rm -rf ./test

RUN find /usr/local/bundle/gems/ -name "*.c" -delete

FROM builder AS production

RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

COPY --from=stripper --chown=app:app /usr/local/bundle/ /usr/local/bundle/

WORKDIR /artifact