#!/bin/sh

docker compose down

git add .
docker compose build roro-ruby
docker compose build roro-base
docker compose build roro-development
docker compose build roro-production
docker compose build roro