#!/bin/sh

dcd

# export PRODUCTION_KEY=$(cat mise/keys/production.key)

# . mise/scripts/docker.prune.club.sh 
# . mise/scripts/docker-prune-all.sh 

dc build --with-dependencies builder-production
dc build production

