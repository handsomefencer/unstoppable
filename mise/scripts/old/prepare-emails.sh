#!/bin/bash

## build production emails in maizzle container
docker compose down 
docker compose build maizzle   
docker compose run --rm maizzle npm run build 

# cp -r ../maizzle-compose/build_* .
cp -r ../maizzle-compose/build_production/devise app/views/