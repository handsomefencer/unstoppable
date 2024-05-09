#!/bin/bash

cd ${sandbox_dir} 

schown .

docker compose build --with-dependencies test

dc run --rm test bin/rails g scaffold post title content
dc run --rm test bin/rails db:migrate
dc run --rm test

cd ${roro}
