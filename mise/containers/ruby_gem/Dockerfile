# syntax=docker/dockerfile:1
FROM ruby:3.0-alpine

RUN apk add --update \
    build-base \
    file \
    git \
    tzdata \
    docker \
    docker-compose \
    sudo \
    libffi-dev

RUN gem install bundler:2.3.2

WORKDIR /usr/src

COPY . .

RUN bundle install -j4 --retry 3

RUN rake install
RUN gem build roro.gemspec

WORKDIR /home/schadenfred

