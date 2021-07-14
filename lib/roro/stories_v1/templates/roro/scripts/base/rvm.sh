#!/bin/zsh --login

set -e
set -a

rvm_ruby_and_gemset_set() {
  case $1 in
  api)
    RORO_RVM_RUBY="jruby-9.2.9.0"
    RORO_RVM_GEMSET="api"
    ;;
  client-api)
    RORO_RVM_RUBY="ruby-3.0.1"
    RORO_RVM_GEMSET="client-api"
    ;;
  public-api)
    RORO_RVM_RUBY="2.7.2"
    RORO_RVM_GEMSET="public-api"
    ;;
  tokenizer-rails)
    RORO_RVM_RUBY="2.6.5"
    RORO_RVM_GEMSET="tokenizer-rails"
    ;;
  esac

  RORO_RVM_RUBY_AND_GEMSET="${RORO_RVM_RUBY}@${RORO_RVM_GEMSET}"
}

rvm_ruby_and_gemset_use() {
  rvm_ruby_and_gemset_set $1
  rvm use "${RORO_RVM_RUBY_AND_GEMSET}" --create
}

rvm_ruby_and_gemset_create() {
  rvm_ruby_and_gemset_set $1
  rvm install "${RORO_RVM_RUBY}"
  rvm use "${RORO_RVM_RUBY_AND_GEMSET}" --create
}
