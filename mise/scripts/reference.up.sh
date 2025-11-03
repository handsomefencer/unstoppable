#!/bin/bash

cd ${sandbox_dir} 

sudo chown -R $USER:$USER .

. mise/scripts/build.development.sh 
. mise/scripts/build.test.sh 

docker compose run --rm --no-deps dev bin/rails g scaffold post title content

. mise/scripts/up.development.sh 

sudo chown -R $USER:$USER .

cd ${roro}
