# syntax=docker/dockerfile:1
FROM ruby:3.2.1-alpine AS builder

RUN apk add \
    build-base \
    file \
    git \
    docker \
    docker-compose \
    sudo

FROM builder AS development

RUN gem install bundler:2.4.13

WORKDIR /usr/src

COPY . .

RUN bundle install -j4 --retry 3

COPY lib .
COPY test .

FROM builder AS stripper

WORKDIR /usr/src

COPY . .

RUN bundle config --local without 'development test' 
RUN bundle install -j4 --retry 3 
RUN bundle exec bootsnap precompile --gemfile || true  
RUN bundle clean --force
RUN rm -rf /usr/local/bundle/cache
RUN find /usr/local/bundle/gems/ -name "*.c" -delete
RUN find /usr/local/bundle/gems/ -name "*.o" -delete

RUN rm -rf  vendor/bundle test 

FROM builder AS production

WORKDIR /artifact

RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

# Copy app with gems from former build stage
COPY --from=stripper --chown=app:app /usr/local/bundle/ /usr/local/bundle/
