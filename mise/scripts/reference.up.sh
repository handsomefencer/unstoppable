#!/bin/bash

cd ${sandbox_dir} 

schown .

. mise/scripts/build.development.sh 
. mise/scripts/build.test.sh 

docker compose run --rm --no-deps dev bin/rails g scaffold post title content

. mise/scripts/up.development.sh 

schown .

cd ${roro}
