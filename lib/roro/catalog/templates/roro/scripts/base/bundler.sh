#!/bin/zsh --login

set -e
set -a
DEFAULT_BRANCH='development'

bundle_install () {
  REPO=${1}
  BRANCH=${2:-$DEFAULT_BRANCH}

  cd "${WORKBENCH}/${REPO}"
  rvm_ruby_and_gemset_use "${REPO}"

  pretty_echo "Checking out git branch: " "${BRANCH}..."
  pretty_echo "Bundling gems in:        " "${WORKBENCH}/${REPO}"
  pretty_echo "Git branch:              " "$(git status)"
  pretty_echo "Bundling with:           " "${RORO_RVM_RUBY_AND_GEMSET}"
  pretty_echo "Current directory:       " "${PWD}"
  pretty_echo "Current directory:       " "${REPO}"
  rvm_ruby_and_gemset_create "${REPO}"  gem install bundler
  bundle install
}