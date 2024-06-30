#!/bin/bash

# docker compose run --rm roro roro generate:obfuscated
bundle exec rake ci:prepare
git add .
git commit -m 'Test build'
git push origin 2408
