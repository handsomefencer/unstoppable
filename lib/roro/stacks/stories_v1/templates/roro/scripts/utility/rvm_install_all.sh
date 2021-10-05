#!/bin/zsh --login

set -e
set -a

WORKBENCH="${PWD}"
source ${WORKBENCH}/roro/scripts/roro.sh

rvm_ruby_and_gemset_create api
rvm_ruby_and_gemset_create client-api
rvm_ruby_and_gemset_create public-api
rvm_ruby_and_gemset_create tok