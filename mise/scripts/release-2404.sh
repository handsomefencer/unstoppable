#!/bin/sh

roro=~/work/handsomefencer/roro-stories-2204
store=~/work/handsomefencer/story_store/

cd $roro && \
  docker compose down && \
  git add . && \
  docker compose build --no-cache dev

cd $store && \
  docker compose down && \
  sudo rm -rf .harvest && \
  docker compose run --rm roro-dev roro generate:harvest