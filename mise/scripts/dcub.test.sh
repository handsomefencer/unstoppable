#!/bin/sh

dcd 

docker compose build --with-dependencies builder-development
docker compose build development
