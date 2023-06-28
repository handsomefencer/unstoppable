#!/bin/bash

greenfield=~/sandbox/greenfield
roro=~/work/handsomefencer/gems/roro
gcam 'getsome'
git push origin mysql
cd ${greenfield} 
docker-compose down
docker volume rm greenfield_db_data
docker rm artifact 

cd ${roro}

sudo rm -rf ${greenfield}
mkdir -p ${greenfield} 

dc build roro  

cd ${greenfield} 

docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest printf "1\n3\n1\n2\n2\n1\na\n" | roro rollon
  # -it handsomefencer/roro:latest roro rollon

schown  
dc build
dc run --rm app bundle 
dc up --build