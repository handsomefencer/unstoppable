# syntax=docker/dockerfile:1

FROM ruby:3.3.0-alpine

RUN gem update --system \
    && gem cleanup \
    && bundle config jobs 4 \
    && bundle config retry 4