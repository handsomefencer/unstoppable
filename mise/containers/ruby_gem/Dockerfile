ARG RUBY_VERSION=${RUBY_VERSION}
ARG RUBY_IMAGE=ruby:${RUBY_VERSION}-alpine
FROM $RUBY_IMAGE

RUN apk add --no-cache --update build-base linux-headers git

ENV APP_HOME /usr/src/app/
ENV BUNDLE_PATH /gems
ENV GEM_PATH ${BUNDLE_PATH}
ENV GEM_HOME ${BUNDLE_PATH}

RUN mkdir ${BUNDLE_PATH}

WORKDIR ${APP_HOME}
COPY . ${APP_HOME}
RUN bundle install
