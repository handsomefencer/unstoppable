# syntax=docker/dockerfile:1

FROM ruby:3.2.1-alpine AS base

RUN apk add --update --no-cache \
  file \
  gcompat \
  tzdata 

FROM base AS builder

RUN apk add --update --no-cache \
  build-base \
  git \
  nodejs \
  npm \
  vips-dev \
  yarn 

RUN apk add --update --no-cache \
  postgresql-dev 

RUN gem install bundler:2.4.13
COPY  Gemfile* ./app/

FROM builder AS development

RUN bundle install -j4 --retry 3

WORKDIR /app

COPY . .

RUN yarn install
RUN chmod -R 755 entrypoints/docker-entrypoint.sh

CMD ["./entrypoints/docker-entrypoint.sh"]

FROM builder AS cleaner

RUN bundle config --local without 'development test' 
RUN bundle install -j4 --retry 3 
RUN bundle exec bootsnap precompile --gemfile || true  
RUN bundle clean --force
RUN rm -rf /usr/local/bundle/cache
RUN find /usr/local/bundle/gems/ -name "*.c" -delete
RUN find /usr/local/bundle/gems/ -name "*.o" -delete

# Copy the whole application folder into the image
COPY . /app

# Precompile application code with Bootsnap (and ignore errors)
RUN bundle exec bootsnap precompile app/ lib/ || true
RUN bundle exec rails assets:precompile

# Remove folders not needed in resulting image
# This includes `app/javascript` which contains the JavaScript source code.
# Normally it is not needed in the resulting image, because it was compiled
# to `public/`. But if the app uses importmaps, the folder is still required
# for pinning and must not be removed.
RUN rm -rf node_modules yarn.lock .yarn vendor/bundle test spec app/packs
RUN if [ ! -f config/importmap.rb ]; then rm -rf app/javascript; fi

FROM base AS production


RUN apk add --no-cache \
  xz-libs \
  brotli-libs 

RUN apk add --no-cache \
  postgresql-client 

WORKDIR /app

