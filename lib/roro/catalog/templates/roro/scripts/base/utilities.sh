#!/bin/zsh

echo $DEV_ENV
source_environment() {
  if [ -n "$DEV_ENV" ]; then
    ENV_SOURCED_FROM=RubyMine
  else
    ENV_SOURCED_FROM=${ENVDIR}/current.env
    . "${ENV_SOURCED_FROM}"
  fi
}


pretty_echo() {
  echo "  ${DEFAULT_COLOR}${1}"
  echo "\t${GREEN}${2}${DEFAULT_COLOR}"
}

include() {
  FILE="${RORODIR}/${1}"
  if [ -f $FILE ]; then
    pretty_echo "Sourcing:" "${GREEN}${FILE}" >&2
    source $FILE
  else
    pretty_echo "No override at:" "${YELLOW}${FILE}" >&2
  fi
}

confirm_if_overwrite () {
  DIRECTORY="${PWD}/${1}"
  if test -d "${DIRECTORY}"; then
    echo "${DIRECTORY} exists."
    read -p "Copy over existing ${DIRECTORY} directory? " answer
    case ${answer:0:1} in y|Y )
      mkdir -p backup
      mv ${DIRECTORY} ./backup/
      ;;
      * )
    ;;
    esac
  fi
}

yarn_install() {
  REPO=${1}

  cd "${WORKBENCH}/${REPO}"
  pretty_echo "Initializing any git submodules..."
  git submodule init .
  pretty_echo "Running yarn install in:" "${PWD}"
  yarn install
  cd ..
}