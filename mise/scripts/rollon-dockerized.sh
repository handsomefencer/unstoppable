#!/bin/bash

SRC=~/work/opensource/gems/roro
DST=~/work/opensource/gems/sandbox

(
  cd $SRC
  sudo docker-compose build
)

(
  cd $DST
  if [[ $PWD = !$DST ]]; then
    echo "Wrong directory"
    exit
  fi

  docker-compose down

  sudo rm -rf ./* ./.*

  sudo docker run \
    -v $PWD:/home/schadenfred \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -u 0 \
     roar:latest printf "1\na\n" | roro rollon
#    -it roar:latest roro rollon


)

  #  printf "2\n4\na$var\n" | roro rollon

#    sudo rm -rf ./* ./.*

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
##docker system prune --volumes
##(cd ~/work/opensource/gems/workbench_roro/roro && docker-compose build)
#
#sudo docker run \
#-v $PWD:/home/schadenfred \
#-v /var/run/docker.sock:/var/run/docker.sock \
#-u 0 \
#-it roar:latest roro rollon
#
