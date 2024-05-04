#!/bin/sh

docker compose down

docker compose build --with-dependencies builder-production
docker compose build production

