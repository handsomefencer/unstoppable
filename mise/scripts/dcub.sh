#!/bin/sh

dcd

# . mise/scripts/docker-prune-roro.sh 
# . mise/scripts/docker-prune-all.sh 
. mise/scripts/docker-info.sh 
. mise/scripts/docker-build.sh 

dc build test
dc run --rm guard
