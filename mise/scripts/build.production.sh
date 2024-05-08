#!/bin/sh

docker compose down

git add .
docker compose build --with-dependencies production
docker compose build roro