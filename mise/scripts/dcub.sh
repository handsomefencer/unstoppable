#!/bin/sh

set -a 

docker compose down
# docker system prune -f
# docker image rm -f $(docker images handsomefencer/roro)
# docker image rm -f $(docker images handsomefencer/roro/builder)
# docker image rm -f $(docker images handsomefencer/roro/development)
# docker image rm -f $(docker images handsomefencer/ruby)
# docker volume rm -f $(docker volume ls --filter name=roro-stories*)
# docker system prune -f
# docker volume rm $(docker volume ls --filter name=gem_cache*)
# docker images

dc build --no-cache ruby
dc build --no-cache builder
dc build --no-cache development
# dc build --no-cache --with-dependencies test
# dc build guard
# dc run --rm guard

