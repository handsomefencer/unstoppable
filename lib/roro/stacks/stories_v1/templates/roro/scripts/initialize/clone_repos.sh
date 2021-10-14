#!/bin/zsh

DEFAULT_BRANCH='development'

clone_repo () {
  REPO=${1}
  BRANCH=${2:-$DEFAULT_BRANCH}

  echo "Cloning ${REPO} into ${PWD}..."

  confirm_if_overwrite ${REPO}

  {
    git clone git@bitbucket.org:corptools/${REPO}.git
  } || {
    git clone https://${LOGNAME}@bitbucket.org/corptools/roro.git
  }

  SUCCESS+=("Successfully cloned ${green}$REPO${default}")
}

clone_repo api
clone_repo client-api
clone_repo ct-frontend
clone_repo frontend
clone_repo internal-docs master
clone_repo affiliate-api-docs master
clone_repo public-api
clone_repo tokenizer-rails

for MESSAGE in "${SUCCESS[@]}"; do
  echo $MESSAGE
done