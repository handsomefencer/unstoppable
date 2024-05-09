#!/bin/bash

export app='foobar'
export sandbox_dir=~/sandbox/${app}
export roro=~/work/handsomefencer/club/roro-stories-2204

# . mise/scripts/docker.prune.sh
. mise/scripts/build.production.sh
. mise/scripts/reference.remove.sh
. mise/scripts/reference.build.sh
. mise/scripts/reference.up.sh


