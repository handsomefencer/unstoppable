FROM ruby:2.7.4-alpine

RUN apk add --update \
  build-base \
  file \
  git \
  nodejs \
  tzdata \
  yarn

RUN apk add --update\
  sqlite-dev

RUN gem install bundler:2.2.28

WORKDIR /app
  
  ## Install standard gems
COPY Gemfile Gemfile.lock ./
RUN bundle install -j4 --retry 3

COPY . .

RUN chmod -R 755 entrypoints/docker-entrypoint.sh

RUN yarn install

CMD ["./entrypoints/docker-entrypoint.sh"]