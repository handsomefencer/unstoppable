#!/bin/sh

docker compose down

git add .
docker compose build --with-dependencies builder-production
docker compose build production