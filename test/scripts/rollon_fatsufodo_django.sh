#!/bin/bash

( cd roro &&
  bundle &&
  gem build roro.gemspec )
( mkdir -p sandbox/django &&
  cd sandbox/django &&
  rvm install 2.7.3 &&
  rvm use 2.7.3@sandbox --create &&
  gem install --local ../../roro/roro-*.gem  &&
  roro --help &&
  sudo docker-compose down &&
  sudo rm -rf *
  printf "1\n1\na$var\n" | roro rollon
)