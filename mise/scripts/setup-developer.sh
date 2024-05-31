#!/bin/sh

## In case any services listed in docker-compose.yml are up:
docker compose down 

## optional -- clear away all images, containers and networks 
### prune 
docker system prune -f
docker image rm $(docker images handsomefencer/club*)
docker volume rm $(docker volume ls)


## Put base.key, development.key, and test.key into ./mise/keys such that 
#     $ ls mise/keys 
#   base.key  ci.key  development.key  production.key  staging.key  test.key

## Generate base, development and test environment files: 
docker compose -f docker-compose.roro.yml run --rm roro roro generate:exposed base development test 

## Start the test service which builds the dev image it uses: 
docker-compose build ruby
docker-compose build rails
docker-compose build builder

docker compose up -d --build prod-local 

## Confirm services the test service depends on -- dev, vite, redis, chrome -- are running: 
#     $ docker ps

## Clear out assets and tmp -d files:
# docker compose exec dev bin/rails assets:clobber
# docker compose exec dev bin/rails tmp:clear

## Follow rails setup conventions when we can:
# docker compose exec dev bin/setup

## Seed the database: 
# docker compose exec dev bin/rails db:seed
# docker compose exec dev bin/rails db:fixtures:load FIXTURES='platforms'

## Tell docker compose exec dev bin/vite build
# docker compose run --rm test bin/rails db:create
# docker compose run --rm guard

