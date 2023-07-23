# syntax=docker/dockerfile:1

FROM ruby:3.2.2-alpine AS builder

RUN apk add \
  build-base \ 
  git

WORKDIR /app

## Install rails 
RUN gem install rails -v 7.0.6

## Use Rails to generate a new app. We'll configure it later.
RUN rails new . \
  --skip-bundle \
  --database=mysql 


## Needed later builds:
RUN touch Gemfile.lock

RUN rm config/master.key

FROM scratch AS export-stage

## Copy the generated files onto the host.
COPY --from=builder ./app/ .