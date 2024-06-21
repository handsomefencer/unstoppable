#!/bin/sh

# . mise/scripts/docker.prune.sh 
. mise/scripts/build.builder.sh 

docker compose build builder-development
docker compose build development
docker compose build dev