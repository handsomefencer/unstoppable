# syntax=docker/dockerfile:1
FROM ruby:3.2.1-alpine AS builder

RUN apk add \
    build-base \
    file \
    git \
    docker \
    docker-compose \
    sudo

WORKDIR /usr/src


COPY . .

RUN gem install bundler:2.4.13
RUN bundle install -j4 --retry 3

RUN rm -rf ./lib/roro/stacks

FROM builder AS stacker

COPY ./lib/roro/stacks ./lib/roro/stacks

RUN gem build roro.gemspec
RUN rake install

WORKDIR /artifact
