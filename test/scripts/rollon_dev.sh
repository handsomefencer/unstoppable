#!/bin/bash

rvm use 3.0.3@sandbox --create
bundle
gem build roro.gemspec
gem install --local roro-0.3.29.gem

mkdir -p sandbox/dev
( cd sandbox/dev &&
#  sudo docker-compose down &&
  sudo rm -rf * &&
  roro --help &&
  roro rollon
##  printf "2\n4\na$var\n" | roro rollon
)