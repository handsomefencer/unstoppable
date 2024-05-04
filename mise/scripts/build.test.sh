#!/bin/sh

docker compose down 

docker compose build --with-dependencies builder-development
docker compose build development
