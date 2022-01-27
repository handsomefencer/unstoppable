#!/bin/bash

cd $SRC

sudo docker run \
  -v $PWD:/home/schadenfred \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it roar:latest roro rollon

#  -i roar:latest printf "1\n3\n1\n2\n2\n1\na\n" | roro rollon

#1
#
#
#1
#3
#1
#2
#2
#1