#!/bin/bash

cd ${sandbox_dir} 

schown .

. mise/scripts/build.builder.sh
. mise/scripts/build.development.sh

dc --profile development up -d
dc exec dev bin/rails g scaffold post title content
dc exec dev bin/setup

. mise/scripts/build.test.sh
dc run --rm rake-test

schown .

cd ${roro}
