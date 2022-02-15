#!/bin/bash

cd $DST

sudo docker run \
  -v $PWD:/usr/src \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest roro rollon


sudo docker run  -it handsomefencer/roro:latest roro rollon

