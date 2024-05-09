#!/bin/sh

docker compose build --with-dependencies test
docker compose build test
docker compose build guard