#!/bin/sh

dcd

. mise/scripts/docker.prune.sh 

dc build --with-dependencies --no-cache development