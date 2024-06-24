# syntax=docker/dockerfile:1
ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}-alpine AS Ruby

RUN gem update --system \
  && gem cleanup \
  && bundle config jobs 4 \
  && bundle config retry 4