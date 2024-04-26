#!/bin/sh

# docker compose down

# . mise/scripts/docker.prune.club.sh 
# . mise/scripts/docker.prune.all.sh 

# . mise/scripts/docker.info
docker compose build --with-dependencies builder-test
docker compose run --rm test bin/vite build --mode=test
docker compose run --rm test bin/rails db:create 
docker compose run --rm test bin/rails test:all