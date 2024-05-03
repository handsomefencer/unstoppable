#!/bin/sh

docker system prune -af --volumes
docker volume rm $(docker volume ls)



