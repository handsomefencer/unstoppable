#!/bin/sh

. mise/scripts/build.development.sh 
. mise/scripts/build.test.sh 

export COMPOSE_PROFILES=development,test,setup

docker compose up -d dev-setup
docker compose up -d test-setup
docker compose up -d
docker compose run --rm test