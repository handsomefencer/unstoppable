# syntax=docker/dockerfile:1

FROM handsomefencer/ruby

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

RUN bundle update --bundler