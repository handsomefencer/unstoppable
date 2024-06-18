#!/bin/sh

docker compose down

. mise/scripts/docker.prune.sh 

docker compose build --with-dependencies --no-cache builder-cache