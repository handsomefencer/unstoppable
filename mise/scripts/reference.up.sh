#!/bin/bash

cd ${sandbox_dir} 

schown .

dc build --with-dependencies dev 
dc run --rm dev bin/rails g scaffold post title content
dc run --rm dev bin/rails db:migrate
dc run --rm dev bin/setup
dc up -d 
dc up dev-js
# dc run --rm rake-test

# docker compose build --with-dependencies test-runner
# docker compose run --rm test-runner bundle

# dc run --rm test-runner bin/rails g scaffold post title content
# dc run --rm test-runner bin/rails db:migrate
# dc run --rm rake-test

# docker compose build --with-dependencies dev
# dc run --rm dev bin/setup
# dc up --build -d --remove-orphans dev

schown .
cd ${roro}
