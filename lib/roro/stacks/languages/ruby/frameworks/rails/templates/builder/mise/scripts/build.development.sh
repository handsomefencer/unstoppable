#!/bin/sh

. mise/scripts/build.builder.sh 

docker compose build builder-development
docker compose build dev