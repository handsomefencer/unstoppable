# syntax=docker/dockerfile:1
ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}-alpine AS base

RUN apk add --update --no-cache \
  build-base \  
  docker \
  docker-cli-compose \
  file \
  git \
  ncurses \
  sudo \
  yaml-dev

RUN git config --global --add safe.directory /usr/src

WORKDIR /usr/src/roro
  
RUN gem update --system \
  && gem cleanup \
  && bundle config jobs 4 \
  && bundle config retry 4
  
FROM base AS development

COPY . .

RUN bundle update --bundler
RUN bundle lock --add-platform x86_64-linux

  