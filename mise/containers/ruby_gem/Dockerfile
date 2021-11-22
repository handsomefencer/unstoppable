# syntax=docker/dockerfile:1
FROM ruby:3.0
RUN apt-get update -qq
RUN apt-get install -y docker docker-compose sudo

WORKDIR /usr/src

COPY . .

RUN bundle
RUN rake install

#RUN useradd -ms /bin/bash roro

#WORKDIR /usr/app
#USER roro

ARG USER_ID
ARG GROUP_ID

WORKDIR /home/app

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user
#RUN addgroup --gid $GROUP_ID schadenfred
#RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID schadenfred
#USER schadenfred


#RUN chown -R user:user .

#USER 1000:1000
#RUN gem build roro.gemspec
#RUN #useradd --user-group --system --create-home --no-log-init app
#USER app

## docker run -v /var/run/docker.sock:/var/run/docker.sock -it roar bash

## docker run -v /var/run/docker.sock:/var/run/docker.sock -it --rm --user "$(id -u):$(id -g)" roar roro rollon

#docker build -t --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .