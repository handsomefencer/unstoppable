FROM ruby:2-5-3-alpine

RUN apk add --no-cache --update build-base linux-headers \
    postgresql-dev nodejs tzdata libxml2-dev libxslt-dev imagemagick

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install
COPY . /usr/src/app/
