#!/bin/zsh

DEFAULT_IDEA_FILE=bench

IDEA_FILE=${1:-$DEFAULT_IDEA_FILE}

pretty_echo "Copying RubyMine .idea file: " "${IDEA_FILE}"

confirm_if_overwrite .idea

mkdir -p .idea

cp -r ./roro/ideas/${IDEA_FILE}/runConfigurations .idea/

