#!/bin/bash


cd ${sandbox_dir} 

docker compose down 

# docker compose build builder-development
schown 
docker compose build --with-dependencies --no-cache development
dc up -d dev
# dc exec dev bin/rails g scaffold post title content
# dc exec dev bin/rails db:migrate
# dc exec dev bin/rails db:migrate
# dc exec dev bin/setup

# dc build --with-dependencies test
# dc run --rm test bin/rails db:migrate
# dc up test

# cd ${roro}
