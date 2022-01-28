FROM ruby:2.7.4-alpine

## Base packages
RUN apk add --update \
  build-base \
  file \
  git \
  tzdata \
  nodejs \
  yarn

RUN apk add --update \
  postgresql-dev

## Adventure packagesRUN apk add --update \
build-base \




WORKDIR /app

RUN gem install bundler:2.2.28

COPY Gemfile Gemfile.lock ./
RUN bundle install -j4 --retry 3

COPY . .

RUN chmod -R 755 entrypoints/docker-entrypoint.sh

RUN yarn install

CMD ["./entrypoints/docker-entrypoint.sh"]