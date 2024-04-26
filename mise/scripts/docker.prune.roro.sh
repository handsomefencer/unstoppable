#!/bin/sh

docker image rm -f $(docker images builder/*)
docker image rm -f $(docker images handsomefencer/*)
docker image rm -f $(docker images unstoppable*)
docker system prune -f 
# docker image rm -f $(docker images handsomefencer/base/*)
# docker image rm -f $(docker images development)
# docker image rm -f $(docker images test)
# docker image rm -f $(docker images production)
# docker image rm -f $(docker images story*)
# docker rmi handsomefencer/club/*

docker volume rm $(docker volume ls --filter name=unstoppable*)


. mise/scripts/docker.info.sh