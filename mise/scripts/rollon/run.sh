#!/bin/bash

sudo docker run \
  -v $PWD:/home/schadenfred \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it roar:latest roro rollon

sudo chown -R $USER:$USER .