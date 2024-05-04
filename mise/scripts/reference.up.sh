#!/bin/bash


cd ${sandbox_dir} 

docker compose down 

# docker compose build builder-development
docker compose build --with-dependencies builder-development
schown 
cd ${roro}
