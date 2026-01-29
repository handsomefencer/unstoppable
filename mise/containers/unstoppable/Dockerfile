# syntax=docker/dockerfile:1

FROM roro/roro AS unstoppable

WORKDIR /usr/src/unstoppable

RUN bundle config set local.roro /usr/src/roro

COPY Gemfile* ./
RUN bundle install

COPY . .

  