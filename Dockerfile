FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /roro
WORKDIR /roro
COPY . /roro/
RUN bundle install
RUN rake install
