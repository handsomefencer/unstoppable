#!/bin/bash

cd $DST

sudo docker run \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest roro rollon

#  --name artifact \
#docker cp artifact:/artifact/. .

#  -i roar:latest printf "1\n3\n1\n2\n2\n1\na\n" | roro rollon

