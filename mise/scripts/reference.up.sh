#!/bin/bash


cd ${sandbox_dir} 

docker compose down 

# docker compose build builder-development
docker compose build --with-dependencies builder-development
dc up --build dev
schown 
cd ${roro}
