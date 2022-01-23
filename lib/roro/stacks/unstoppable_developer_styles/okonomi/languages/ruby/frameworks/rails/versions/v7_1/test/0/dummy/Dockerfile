FROM ruby:2.7.4-alpine AS builder

RUN apk add \
  build-base \
  postgresql-dev

RUN apk add --update\
  file \
  git \
  nodejs \
  tzdata \
  yarn

RUN gem install bundler:2.2.28

WORKDIR /app

## Install standard gems
COPY Gemfile Gemfile.lock ./
RUN bundle install -j4 --retry 3

RUN yarn install

COPY . ./

RUN bundle install

CMD ["./entrypoints/docker-entrypoint.sh"]