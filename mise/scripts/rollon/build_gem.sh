#!/bin/bash

cd $SRC
rake install
gem build roro.gemspec
sudo docker-compose build

