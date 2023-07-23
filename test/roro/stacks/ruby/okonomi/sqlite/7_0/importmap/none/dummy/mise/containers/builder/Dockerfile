# syntax=docker/dockerfile:1

FROM ruby:3.2.2-alpine AS builder

RUN apk add \
  build-base \ 
  git

RUN apk add --update --no-cache \
  sqlite-dev 

WORKDIR /app

RUN gem install bundler:2.4.13

COPY  Gemfile* ./
RUN bundle install -j4 --retry 3

## Use Rails to generate a new app. We'll configure it later.
RUN bundle exec rails new . \
  --database=sqlite3 \
  --skip-bundle 

RUN rm config/master.key

FROM scratch AS export-stage

## Copy the generated files onto the host.
COPY --from=builder ./app/ .