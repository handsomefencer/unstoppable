#!/bin/bash

if [[ $PWD = !$DST ]]; then
  echo "Wrong directory"
  exit
elif [[ $PWD = $DST ]]; then
  echo "Removing contents of ${PWD}"
  sudo rm -rf ./*
fi

