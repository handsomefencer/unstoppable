#!/bin/bash

cd ${sandbox_dir} 

docker compose --profile development down
docker compose down
docker image rm -f $(docker images greenfield/*)
docker image rm -f $(docker images greenfield*)
docker volume rm $(docker volume ls -f name=greenfield*)
docker network rm $(docker volume ls -f name=greenfield*)



cd ${roro}

sudo rm -rf ${sandbox_dir}
