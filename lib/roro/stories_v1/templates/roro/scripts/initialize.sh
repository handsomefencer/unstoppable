#!/bin/zsh --login

set -a
set -e

WORKBENCH="${PWD}"
cp ./roro/templates/roro.env.template ./roro/env/roro.env

source ${WORKBENCH}/roro/scripts/roro.sh

cp "${TEMPLATEDIR}/Caddyfile.template"   "${WORKBENCH}/Caddyfile"
cp "${TEMPLATEDIR}/current.env.template" "${RORODIR}/env/current.env"


source "${SCRIPTDIR}"/initialize/clone_idea.sh
source "${SCRIPTDIR}"/initialize/clone_repos.sh
source "${SCRIPTDIR}"/initialize/install_rubies.sh
source "${SCRIPTDIR}"/utility/bundle_all.sh
