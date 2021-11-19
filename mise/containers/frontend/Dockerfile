# syntax=docker/dockerfile:1
FROM ruby:3.0
RUN apt-get update -qq
RUN apt-get install -y docker-compose

WORKDIR /usr/src

COPY . /usr/src/

RUN bundle
RUN rake install

#RUN gem build roro.gemspec
