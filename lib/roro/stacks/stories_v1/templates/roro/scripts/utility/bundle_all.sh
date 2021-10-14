#!/bin/zsh --login

set -e
set -a

WORKBENCH="${PWD}"
source ${WORKBENCH}/roro/scripts/roro.sh

bundle_install api
bundle_install client-api
bundle_install public-api
bundle_install tokenizer-rails
