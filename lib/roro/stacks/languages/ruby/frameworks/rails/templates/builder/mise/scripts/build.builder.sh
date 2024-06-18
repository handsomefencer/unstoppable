#!/bin/sh

docker compose down

docker compose build --with-dependencies builder-cache