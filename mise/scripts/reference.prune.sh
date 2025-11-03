#!/bin/bash

export COMPOSE_PROFILES=development,test,setup

cd ${sandbox_dir} 

docker compose down 

docker system prune -f
docker image rm -f $(docker images greenfield*)
docker image rm -f $(docker images builder/*)

docker volume rm $(docker volume ls -f name=greenfield*)
docker network rm $(docker network ls -f name=greenfield*)

cd ${roro}
