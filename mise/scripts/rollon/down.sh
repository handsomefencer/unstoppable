#!/bin/bash

cd $DST
docker-compose down
docker ps --filter name=sandbox* -a -q | xargs docker stop | xargs docker rm -f
docker volume ls --filter name=sandbox* -q | xargs docker volume rm -f
docker network ls --filter name=sandbox* -q | xargs docker network rm
docker image ls sandbox* -q | xargs docker rmi -f