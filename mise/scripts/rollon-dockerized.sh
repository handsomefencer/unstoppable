#!/bin/bash

SRC=~/work/opensource/gems/roro
DST=~/work/opensource/gems/sandbox

(
  cd $SRC
  rake install
  gem build roro.gemspec
  sudo docker-compose build
)

(
  cd $DST
  if [[ $PWD = !$DST ]]; then
    echo "Wrong directory"
    exit
  else
    docker-compose down
    sudo docker run \
      -v $PWD:/home/schadenfred \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -u 0 \
      -it roar:latest roro rollon
  fi
)
