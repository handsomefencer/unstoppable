#!/bin/bash

docker compose run --rm roro roro generate:obfuscated
git add .
git commit -m 'getsome'
git push origin production
