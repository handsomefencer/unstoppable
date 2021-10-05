#!/bin/zsh --login

set -a
set -e

BENCH_APP="${PWD##*/}"
WORKBENCH="$(dirname ${PWD})"
echo ${BENCH_APP}
echo ${WORKBENCH}

source ${WORKBENCH}/roro/scripts/roro.sh
source "${SCRIPTDIR}"/base.sh

source_environment

include "env/base.env"
include "containers/database/env/base.env"
include "containers/database/env/${DEV_ENV}.env"
include "containers/${BENCH_APP}/env/base.env"
include "containers/${BENCH_APP}/env/${DEV_ENV}.env"

pretty_echo "Dev environment sourced from: " "${ENV_SOURCED_FROM}"
pretty_echo "DEV_ENV:                      " "${DEV_ENV}"
pretty_echo "Bench app:                    " "${BENCH_APP}"
pretty_echo "Ruby and Gemset:              " "${RORO_RVM_RUBY_AND_GEMSET}"
pretty_echo "Database host:                " "${DB_HOST}"
pretty_echo "Database password:            " "${DB_PASSWORD}"

