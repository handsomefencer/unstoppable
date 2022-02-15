#!/bin/bash

SRC=~/work/opensource/gems/roro
DST=~/work/opensource/gems/sandbox
SCRIPTS=${SRC}/mise/scripts/rollon

locations=( $SRC $DST )
for i in "${locations[@]}"
do
  if [ ! -d ${i} ]; then
    echo "Directory ${i} DOES NOT exist."
	  kill -INT $$
	fi
done

#. ${SCRIPTS}/git_commit.sh
. ${SCRIPTS}/down.sh
. ${SCRIPTS}/reset_sandbox.sh
. ${SCRIPTS}/prune.sh
#. ${SCRIPTS}/build_gem.sh
. ${SCRIPTS}/image_push.sh
. ${SCRIPTS}/run.sh
#. ${SCRIPTS}/build_app.sh

cd ${SRC}
