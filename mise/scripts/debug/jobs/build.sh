#!/bin/bash

set -e

## Set rubies to test against:

## Create process.yml that job execute will look for matching jobs in:
circleci config process .circleci/config.yml > process.yml

# Run build
circleci local execute -c process.yml --job build
