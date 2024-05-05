#!/bin/sh

dcd

# . mise/scripts/docker.prune.sh 
. mise/scripts/docker.info.sh 

# dc build --with-dependencies builder-development
dc build  builder-development