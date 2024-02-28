#!/bin/sh

set -a 

docker compose down
docker system prune -f
docker image rm -f $(docker images unstoppable)
docker image rm -f $(docker images handsomefencer/roro)
docker image rm -f $(docker images handsomefencer/roro-builder)
docker image rm -f $(docker images handsomefencer/ruby)
docker volume rm -f $(docker volume ls --filter name=artifact*)
docker system prune -f
docker volume 
docker volume rm $(docker volume ls --filter name=gem_cache*)
docker system prune -af --volumes
docker images
dcd 

dc build --no-cache ruby
dc build --no-cache --with-dependencies builder
dc build --no-cache --with-dependencies developer
dc build --no-cache --with-dependencies test
dc build guard
dc run --rm guard