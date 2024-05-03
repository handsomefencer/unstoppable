#!/bin/sh

# . mise/scripts/docker.prune.sh
docker compose build --with-dependencies builder-test
dc build --no-cache test
docker compose run --rm test bin/vite build --mode=test
docker compose run --rm test bin/rails db:create 
docker compose run --rm test bin/rails test:all 