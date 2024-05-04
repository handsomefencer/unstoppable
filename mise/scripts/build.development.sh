#!/bin/sh

docker compose down

# . mise/scripts/docker.prune.roro.sh

# docker compose build --with-dependencies --no-cache builder-base 
docker compose build builder-development
docker compose build development

# docker compose build  builder-base 
# docker compose build --with-dependencies builder-development
# docker compose build development
# docker compose up 