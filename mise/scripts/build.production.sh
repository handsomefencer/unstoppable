#!/bin/sh

docker compose down

git add .
docker compose build --with-dependencies roro