#!/usr/bin/env bash

# Prefix `bundle` with `exec` so unicorn shuts down gracefully on SIGTERM (i.e. `docker stop`)
exec mv -f config/database.yml.example config/database.yml
exec bundle exec rails s -p 3000 -b '0.0.0.0'
