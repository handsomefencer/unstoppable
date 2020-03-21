FROM ruby:2.6.0-alpine

RUN apk add --no-cache --update build-base linux-headers \
    postgresql-dev nodejs yarn tzdata libxml2-dev libxslt-dev git

WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN rake install
RUN gem install bundler
RUN bundle
