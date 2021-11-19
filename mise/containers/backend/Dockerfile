FROM ruby:3.0-alpine

# Add only packages necessary to use roro
RUN apk add \
  docker-compose \
  build-base \
  git

WORKDIR /usr/app

RUN set -ex && apk --no-cache add sudo
# RUN adduser --disabled-password --gecos '' docker
# RUN addgroup -S docker

# Create a user group 'docker'
RUN addgroup -S roro

# Create a user 'roro' under 'roro'
RUN adduser -S -D -h /usr/app/src roro roro

WORKDIR /roro

RUN gem install roro