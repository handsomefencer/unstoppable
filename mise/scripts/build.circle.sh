#!/bin/bash

docker compose run --rm roro roro generate:obfuscated
git add .
git commit -m 'Test build'
git push origin 2408
