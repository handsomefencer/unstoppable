#!/bin/bash

#set -e

## Set rubies to test against:
rubies=(2.5 2.6 2.7 3.0)

## Create process.yml that job execute will look for matching jobs in:
circleci config process .circleci/config.yml > process.yml

for ruby in ${rubies[@]}; do
  circleci local execute -c process.yml --job test-${ruby}
done
