#!/bin/bash

export app='greenfield'
export sandbox_dir=~/sandbox/${app}
export roro=~/work/handsomefencer/club/roro-stories-2204

# . mise/scripts/docker.prune.roro.sh
. mise/scripts/build.production.sh
. mise/scripts/reference.remove.sh
. mise/scripts/reference.build.sh
. mise/scripts/reference.up.sh


