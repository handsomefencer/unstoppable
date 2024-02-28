#!/bin/bash

set -a
job=$1
bundle exec rake ci:prepare
echo "Running job ${job}"
circleci local execute ${job}