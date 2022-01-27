#!/bin/bash

sudo docker run \
  -v $PWD:/home/schadenfred \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -t roar:latest roro rollon
#  -t roar:latest printf "1\\n3\\n1\\n2\\n2\\n1\\na\\n$var" | roro rollon

