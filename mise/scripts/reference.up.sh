#!/bin/bash

cd ${sandbox_dir} 

schown .

. mise/scripts/build.development.sh
. mise/scripts/build.test.sh

export COMPOSE_PROFILES=development

docker compose up -d --build 
# docker compose exec dev bin/rails g scaffold post title content
# docker compose exec dev bin/setup
# docker compose exec dev bin/rails db:migrate

docker compose run --rm test 
docker compose run --rm rake-test
# docker compose up -d

# docker compose
# docker compose exec dev bin/rails db:migrate
# docker compose exec dev bin/setup


# docker compose exec dev bin/rails g scaffold post title content
# docker compose --profile development up -d --build dev db
# docker compose --profile development up -d --build dev db
# docker compose run --rm dev bin/rails g scaffold post title content
# docker compose exec dev bin/setup

# dc run --rm rake-test

schown .

cd ${roro}
