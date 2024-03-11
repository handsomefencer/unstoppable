# syntax=docker/dockerfile:1

FROM handsomefencer/ruby:3.3.0-alpine

RUN apk add --update --no-cache \
    build-base \  
    docker \
    docker-compose \
    file \
    git \
    ncurses \
    sudo

RUN git config --global --add safe.directory /usr/src

WORKDIR /usr/src

COPY . .

RUN bundle
RUN gem build roro.gemspec
RUN bundle exec rake install