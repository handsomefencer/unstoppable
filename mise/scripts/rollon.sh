#!/bin/bash

SRC=~/work/opensource/gems/roro
DST=~/work/opensource/gems/sandbox
SCRIPTS=${SRC}/mise/scripts/rollon

. ${SCRIPTS}/git_commit.sh
. ${SCRIPTS}/build_gem.sh
. ${SCRIPTS}/down.sh
. ${SCRIPTS}/reset_sandbox.sh
. ${SCRIPTS}/run.sh
#. ${SCRIPTS}/build_app.sh

cd ${SRC}
