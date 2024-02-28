# syntax=docker/dockerfile:1

FROM handsomefencer/ruby:3.3.0-alpine

RUN apk add --no-cache \
    file \
    sudo

RUN apk add --no-cache \
    docker \
    docker-compose

RUN apk add --no-cache \
    build-base \  
    git 

RUN git config --global --add safe.directory /usr/src

WORKDIR /usr/src

COPY . .

RUN bundle update --bundler