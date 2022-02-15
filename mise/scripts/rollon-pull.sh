#!/bin/bash

cd $DST

sudo docker run \
  -v $PWD:/usr/src \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest roro rollon


sudo docker run  -it handsomefencer/roro:latest roro rollon


#!/bin/bash

#cd $DST
#
#sudo docker run \
#  --name artifact \
#  -v /var/run/docker.sock:/var/run/docker.sock \
#  -u 0 \
#  -it handsomefencer/roro:latest roro rollon
#
#docker cp artifact:/. .
#
##  -i roar:latest printf "1\n3\n1\n2\n2\n1\na\n" | roro rollon
#
##1
##
##
##1
##3
##1
##2
##2
##1