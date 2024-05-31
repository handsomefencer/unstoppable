#!/bin/sh

docker compose down

# . mise/scripts/docker.prune.roro.sh

docker compose build --with-dependencies development
