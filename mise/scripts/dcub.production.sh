#!/bin/sh

dcd

dc build --with-dependencies builder-production
dc build production




# dc build development

# dc build  builder-base 
# dc build --with-dependencies builder-development
# dc build development
# dc up 