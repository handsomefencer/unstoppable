#!/bin/sh

docker compose down
docker image rm -f $(docker images handsomefencer/roro)
docker image rm -f $(docker images handsomefencer/roro/builder)
docker image rm -f $(docker images handsomefencer/roro/development)
docker image rm -f $(docker images handsomefencer/ruby)
docker volume rm -f $(docker volume ls --filter name=roro-stories*)
docker volume rm $(docker volume ls --filter name=gem_cache*)
docker system prune -f

