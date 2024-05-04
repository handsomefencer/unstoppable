#!/bin/sh

docker compose build --with-dependencies builder-test
docker compose build test
docker compose build guard