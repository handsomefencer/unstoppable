# syntax=docker/dockerfile:1

FROM ruby:3.2.1-alpine

ARG UID=1000
ARG GID=1000

RUN apk add --update \
  build-base \
  file \
  git \
  tzdata \
  nodejs \
  yarn

RUN apk add --update \
  mariadb-dev
  


WORKDIR /app

RUN gem install bundler:2.4.13

COPY Gemfile Gemfile.lock ./
RUN bundle install -j4 --retry 3

COPY --chown=${UID}:${GID} . .

RUN chmod -R 755 entrypoints/docker-entrypoint.sh

RUN yarn install

CMD ["./entrypoints/docker-entrypoint.sh"]