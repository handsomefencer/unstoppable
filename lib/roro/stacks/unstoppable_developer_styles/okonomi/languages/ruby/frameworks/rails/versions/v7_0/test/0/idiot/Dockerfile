# syntax=docker/dockerfile:1

FROM ruby:2.7.4-alpine AS builder

# Add only packages necessary to generate a new rails app


RUN apk add --update \
  sqlite-dev


WORKDIR /app

## Create a Gemfile with just the Rails gem inside:
RUN echo -e "source 'https://rubygems.org'\ngem 'rails', '~> 7.0'" > Gemfile
RUN gem install bundler:2.2.28
RUN bundle config --local && \
  bundle install -j4 --retry 3

## Use Rails to generate a new app. We'll configure it later.
RUN bundle exec rails new . \
  --database=sqlite3 \
  --skip-bundle \
  --skip-webpack-install

FROM scratch AS export-stage

## Copy the generated files onto the host.
COPY --from=builder ./app/ .