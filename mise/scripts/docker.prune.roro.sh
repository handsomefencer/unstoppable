#!/bin/sh

docker image rm -f $(docker images builder/*)
docker image rm -f $(docker images handsomefencer/*)
docker image rm -f $(docker images unstoppable*)

docker volume rm $(docker volume ls --filter name=unstoppable*)

. mise/scripts/docker.info.sh