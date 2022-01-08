#!/bin/bash

( cd roro &&
  bundle &&
  gem build roro.gemspec)
( mkdir -p sandbox/wordpress &&
  cd sandbox/wordpress &&
  rvm install 3.0.2 &&
  rvm use 3.0.2@sandbox --create &&
  gem install --local ../../roro/roro-0.3.29.gem  &&
  gem install byebug &&
  roro --help &&
  sudo docker-compose down &&
  sudo rm -rf * &&
  printf "1\n5\ny\ny\ny\ny\ny\ny\ny$var\n" | roro rollon

)

