#!/bin/sh

docker image rm -f $(docker images builder/*)
docker image rm -f $(docker images handsomefencer/*)
docker image rm -f $(docker images unstoppable*)

# docker volume rm $(docker volume ls --filter name=unstoppable*)
# docker volume rm $(docker volume ls -q)

. mise/scripts/docker.info.sh