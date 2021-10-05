#!/bin/zsh --login

DEFAULT_BRANCH='development'

update_repo () {
  REPO=${1}
  BRANCH=${2:-$DEFAULT_BRANCH}

  cd $WORKBENCH/$REPO
  pretty_echo "Updating ${REPO}..."
  pretty_echo "checking out ${BRANCH}..." " "
  git checkout ${BRANCH}
  pretty_echo "fetching origin..."
  git fetch origin
  pretty_echo "pulling latest ${BRANCH} for ${REPO} from origin..."
  git pull origin $BRANCH
  git submodule init .

  SUCCESS+=("Successfully updated ${green}$REPO${default}, branch: ${BRANCH}")
}

