# syntax=docker/dockerfile:1
FROM ruby:3.0
RUN apt-get update -qq
RUN apt-get install -y docker-compose sudo

WORKDIR /usr/src

COPY . .

RUN bundle
RUN rake install

WORKDIR /usr/app

RUN adduser --system --group roro

USER roro


#RUN gem build roro.gemspec
