#!/bin/bash

( cd roro &&
  bundle &&
  gem build roro.gemspec)
( mkdir -p sandbox/roll_your_own &&
  cd sandbox/roll_your_own &&
  rm -rf *
  rvm install 2.7.3 &&
  rvm use 2.7.3@sandbox --create &&
  gem install --local ../../roro/roro-0.3.24.gem  &&
  roro --help
#  roro generate
#  roro generate -c mariadb nginx pistil stamen
  roro generate
#  printf "2\n1\ny\ny\ny\ny\ny\ny\ny$var\n" | roro rollon
#  sudo rm -rf *
#  roro generate:mise
##  printf "2\n1\ny\ny\ny\ny\ny\ny\ny$var\n" | roro rollon
#  roro rollon
#>>>>>>> v2

)

