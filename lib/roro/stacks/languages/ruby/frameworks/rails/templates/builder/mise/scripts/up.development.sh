#!/bin/sh

export COMPOSE_PROFILES=development,test,setup

# . mise/scripts/docker.prune.sh
. mise/scripts/docker.info.sh

docker compose build builder-base
docker compose build builder-deps-dev
docker compose build builder-cache
docker compose build builder-development
docker compose build builder-test

docker compose up 

