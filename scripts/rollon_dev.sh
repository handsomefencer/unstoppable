#!/bin/bash

rvm use 3.0.3@sandbox --create
bundle
gem build roro.gemspec
gem install --local roro-0.3.29.gem

mkdir -p sandbox/dev
( cd sandbox/dev &&
  sudo rm -rf * &&
  roro --help &&
  printf "3\n2\n1\n2\n2\n2\n1\na$var\n" | roro rollon
)