#!/bin/bash

export app='greenfield'
export sandbox_dir=~/work/sandbox/${app}
export roro=~/work/handsomefencer/unstoppable

# . mise/scripts/docker.prune.sh
. mise/scripts/reference.remove.sh
. mise/scripts/build.production.sh
. mise/scripts/reference.build.sh
. mise/scripts/reference.up.sh


