FROM ruby:2.5-alpine

RUN apk add --no-cache --update build-base linux-headers \
    postgresql-dev nodejs tzdata libxml2-dev libxslt-dev

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/Gemfile
RUN bundle install
COPY . /usr/src/app/
