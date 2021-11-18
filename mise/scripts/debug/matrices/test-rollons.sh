#!/bin/bash

#set -e

## Set rubies to test against:
#rubies=(2.4)

## Create process.yml that job execute will look for matching jobs in:
circleci config process .circleci/config.yml > process.yml

#for ruby in ${rubies[@]}; do
  circleci local execute -c process.yml --job test-rollon-1\\n1-linux
#  circleci local execute -c process.yml --job test-rollon-3\\n2\\n1\\n1-linux
#done
