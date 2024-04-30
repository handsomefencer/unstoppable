#!/bin/sh

dcd

git add .
# dc build --with-dependencies builder-production
dc build builder-production
dc build production