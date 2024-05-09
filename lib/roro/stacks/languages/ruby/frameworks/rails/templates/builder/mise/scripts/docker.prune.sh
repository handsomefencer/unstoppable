#!/bin/sh

docker image rm -f $(docker images foobar/*)
docker volume rm $(docker volume ls)



