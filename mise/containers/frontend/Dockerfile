# syntax=docker/dockerfile:1
FROM ruby:3.0
RUN apt-get update -qq
RUN apt-get install -y docker docker-compose sudo

WORKDIR /usr/src

COPY . .

RUN bundle
RUN rake install

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN addgroup --gid $GROUP_ID schadenfred
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID schadenfred
USER schadenfred

WORKDIR /home/schadenfred
VOLUME ["/home/schadenfred"]


RUN chown -R schadenfred:schadenfred .

#USER 1000:1000
#RUN gem build roro.gemspec
#RUN #useradd --user-group --system --create-home --no-log-init app
#USER app

## docker run -v /var/run/docker.sock:/var/run/docker.sock -it roar bash