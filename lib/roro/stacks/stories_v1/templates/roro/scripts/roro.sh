#!/bin/zsh --login

set -a
set -e

RORODIR="${WORKBENCH}/roro/"
ENVDIR="${RORODIR}/env/"
SCRIPTDIR="${RORODIR}/scripts/"
TEMPLATEDIR="${RORODIR}/templates/"

source "${ENVDIR}"/roro.env

source ${SCRIPTDIR}/base.sh


