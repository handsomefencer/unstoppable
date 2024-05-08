#!/bin/bash


cd ${sandbox_dir} 

docker compose down 

# docker compose build builder-development
docker compose build --with-dependencies builder-development
schown 
dc up --build -d dev
dc exec dev bin/rails g scaffold post title content
dc exec dev bin/rails db:migrate
dc exec dev bin/rails db:migrate
dc exec dev bin/setup

dc build builder-test
dc run --rm test bin/rails db:migrate
dc up test

cd ${roro}
