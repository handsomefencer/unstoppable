#!/bin/sh

set -a 

. mise/scripts/docker-prune-roro.sh 
. mise/scripts/docker-prune-all.sh 
. mise/scripts/docker-info.sh 
. mise/scripts/build.sh 
