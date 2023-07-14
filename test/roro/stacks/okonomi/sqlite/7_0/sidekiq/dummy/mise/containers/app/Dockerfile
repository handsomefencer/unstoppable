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
  sqlite-dev 

FROM builder AS development

RUN gem install bundler:2.4.13
WORKDIR /app

COPY  Gemfile* ./

RUN bundle install -j4 --retry 3

COPY . .

RUN yarn install

RUN chmod -R 755 entrypoints/docker-entrypoint.sh

CMD ["./entrypoints/docker-entrypoint.sh"]

FROM builder AS stripper

WORKDIR /app

COPY Gemfile* .

RUN bundle config --local without 'development test' 
RUN bundle install -j4 --retry 3 
RUN bundle exec bootsnap precompile --gemfile || true  
RUN bundle clean --force
RUN rm -rf /usr/local/bundle/cache
RUN find /usr/local/bundle/gems/ -name "*.c" -delete
RUN find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . /app

RUN bundle exec bootsnap precompile app/ lib/ || true
RUN bundle exec rails assets:precompile

RUN rm -rf node_modules yarn.lock .yarn vendor/bundle test spec app/packs
RUN if [ ! -f config/importmap.rb ]; then rm -rf app/javascript; fi

FROM base AS production

RUN apk add --no-cache \
  xz-libs \
  brotli-libs 

RUN apk add --no-cache \
  sqlite-dev 

WORKDIR /app

RUN addgroup -g 1000 -S app && \
  adduser -u 1000 -S app -G app

COPY --from=stripper --chown=app:app /usr/local/bundle/ /usr/local/bundle/
COPY --from=stripper --chown=app:app /app /app

RUN chmod -R 755 entrypoints/docker-entrypoint.sh

CMD ["./entrypoints/docker-entrypoint.sh"]