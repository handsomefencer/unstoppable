#!/bin/zsh --login

set -e
set -a

WORKBENCH="${PWD}"
source ${WORKBENCH}/roro/scripts/roro.sh

update_repo api
update_repo client-api
update_repo ct-frontend
update_repo frontend
update_repo internal-docs master
update_repo affiliate-api-docs master
update_repo public-api
