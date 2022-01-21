#!/bin/bash

SRC=~/work/opensource/gems/roro
DST=~/work/opensource/gems/sandbox
SCRIPTS=${SRC}/mise/scripts/rollon

. ${SCRIPTS}/build_gem.sh
. ${SCRIPTS}/down.sh
. ${SCRIPTS}/reset_sandbox.sh
. ${SCRIPTS}/run.sh

cd ${SRC}
