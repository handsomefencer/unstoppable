#!/bin/sh

roro=~/work/handsomefencer/roro-stories-2204
store=~/work/handsomefencer/story_store/

cd $roro && \
  dcd && \
  git add . && \
  dc build --no-cache dev

cd $store && \
  dcd && \
  sudo rm -rf .harvest && \
  dc run --rm roro-dev roro generate:harvest