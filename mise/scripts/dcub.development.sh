#!/bin/sh

dcd

# . mise/scripts/docker.prune.roro.sh

# dc build --with-dependencies --no-cache builder-base 
dc build builder-development
dc build development

# dc build  builder-base 
# dc build --with-dependencies builder-development
# dc build development
# dc up 