#!/bin/bash

set -e

echo "Running job ${job}"
circleci local execute -c process.yml --job ${job}

# circleci project dlc purge github schadenfred roro
# 