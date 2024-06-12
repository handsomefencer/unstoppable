#!/bin/sh

. mise/scripts/build.builder.sh 

docker compose build builder-test
docker compose build test