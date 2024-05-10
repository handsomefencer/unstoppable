#!/bin/bash

cd ${sandbox_dir} 

schown .

docker compose build --with-dependencies test

dc run --rm test-runner bin/rails g scaffold post title content
dc run --rm test-runner bin/rails db:migrate
dc run --rm rake-test

cd ${roro}
