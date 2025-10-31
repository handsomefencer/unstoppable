#!/bin/bash

export app='greenfield'
export sandbox_dir=~/Work/sandbox/${app}
export roro=~/Work/handsomefencer/unstoppable

# . mise/scripts/docker.prune.sh
. mise/scripts/reference.prune.sh
. mise/scripts/reference.remove.sh
. mise/scripts/docker.info.sh
. mise/scripts/build.production.sh
. mise/scripts/reference.build.sh
. mise/scripts/reference.up.sh

git init .
git add .
git commit -m 'initial commit'


