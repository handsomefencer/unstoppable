#!/bin/zsh --login

set -e
set -a

WORKBENCH="${PWD}"
source ${WORKBENCH}/roro/scripts/roro.sh

yarn_install frontend
yarn_install ct-frontend