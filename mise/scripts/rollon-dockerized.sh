#!/bin/bash

SRC=~/work/opensource/gems/roro
DST=~/work/opensource/gems/sandbox

if [[ $PWD = $DST ]]; then
    echo 'getsome'
elif [[ $ans1_1 = n ]]; then
    :
else
    echo "Answer 'y' or 'n'"
fi

#(
#  cd $SRC
#  sudo docker-compose build
#)



#(
#  cd ../../roro &&
#  echo $SRC
#  echo $DST
#  sudo docker-compose build
#
#)
#sudo rm -rf ./* ./.*
##docker system prune --volumes
##(cd ~/work/opensource/gems/workbench_roro/roro && docker-compose build)
#
#sudo docker run \
#-v $PWD:/home/schadenfred \
#-v /var/run/docker.sock:/var/run/docker.sock \
#-u 0 \
#-it roar:latest roro rollon
#
