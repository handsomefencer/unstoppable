# syntax=docker/dockerfile:1
FROM ruby:3.0-alpine AS builder

RUN apk add \
    build-base \
    file \
    git \
    docker \
    docker-compose \
    sudo

WORKDIR /usr/src

RUN gem install bundler:2.2.32

COPY . .

RUN bundle install -j4 --retry 3

RUN rm -rf ./lib/roro/stacks

FROM builder AS stacker

WORKDIR /usr/src

COPY ./lib/roro/stacks ./lib/roro/stacks

RUN gem build roro.gemspec
RUN rake install


