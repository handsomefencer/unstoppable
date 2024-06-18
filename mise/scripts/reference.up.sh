#!/bin/bash

cd ${sandbox_dir} 

schown .

. mise/scripts/build.development.sh
. mise/scripts/build.test.sh

# docker compose --profile development up -d --build dev db
# docker compose --profile development up -d --build dev db
docker compose run --rm dev bin/rails g scaffold post title content
# docker compose run --rm dev bin/setup
# docker compose exec dev bin/setup

# dc run --rm rake-test

schown .

cd ${roro}
