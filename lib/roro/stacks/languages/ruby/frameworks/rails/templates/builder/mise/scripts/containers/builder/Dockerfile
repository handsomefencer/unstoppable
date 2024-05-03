# syntax=docker/dockerfile:1

FROM ruby:3.3-alpine AS base

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

FROM builder AS generator

WORKDIR /app

RUN gem install bundler:2.4.13
RUN echo -e "source 'https://rubygems.org'\ngem 'rails', '~> 7.1.3'" > Gemfile

RUN bundle install -j4 --retry 3

## Use Rails to generate a new app. We'll configure it later.

RUN bundle exec rails new . \
  -d postgresql \
  -j esbuild




RUN bundle remove jsbundling-rails
RUN bundle add vite_rails vite_ruby
RUN bundle 

RUN bundle exec vite install

RUN yarn add tailwindcss \
  autoprefixer \
  @tailwindcss/aspect-ratio \
  @tailwindcss/forms \
  @tailwindcss/line-clamp \
  @tailwindcss/typography 

RUN yarn add -D eslint \
  eslint-config-prettier \
  eslint-plugin-prettier \
  eslint-plugin-tailwindcss \
  path \
  prettier \
  vite-plugin-full-reload \
  vite-plugin-stimulus-hmr

RUN yarn tailwind init 
RUN rails g controller Home index

RUN rm config/master.key

FROM scratch AS export-stage

## Copy the generated files onto the host.
COPY --from=generator ./app/ .