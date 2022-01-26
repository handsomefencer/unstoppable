#!/bin/bash

sudo docker run \
  -v $PWD:/home/schadenfred \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -t roar:latest printf "2\n1\n$var" | roro rollon

