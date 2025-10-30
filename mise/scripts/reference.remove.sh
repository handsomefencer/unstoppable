#!/bin/bash

cd ${sandbox_dir} 

export COMPOSE_PROFILES=development,test,setup

docker compose down 
docker image rm -f $(docker images greenfield/*)
docker volume rm $(docker volume ls -f name=greenfield*)
docker network rm $(docker network ls -f name=greenfield*)

cd ${roro}

sudo rm -rf ${sandbox_dir}
