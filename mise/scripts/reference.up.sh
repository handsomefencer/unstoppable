#!/bin/bash

cd ${sandbox_dir} 

schown .

. mise/scripts/build.builder.sh
. mise/scripts/build.development.sh

docker compose --profile development up -d
docker compose exec dev bin/rails g scaffold post title content
docker compose exec dev bin/setup

# . mise/scripts/build.test.sh
# dc run --rm rake-test

schown .

cd ${roro}
