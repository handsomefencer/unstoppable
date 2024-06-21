#!/bin/bash

cd ${sandbox_dir} 

schown .

. mise/scripts/build.development.sh
. mise/scripts/build.test.sh

export COMPOSE_PROFILES=development,test

docker compose run --rm dev bin/rails g scaffold post title content
docker compose up -d --build 
docker compose run --rm test

schown .

cd ${roro}