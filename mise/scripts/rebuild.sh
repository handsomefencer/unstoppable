#!/bin/bash

app='111'
sandbox_dir=~/sandbox/${app}
roro=~/work/handsomefencer/gems/roro

git add .

cd ${sandbox_dir} 
docker-compose down
docker system prune
docker volume rm ${app}_db_data
docker volume rm ${app}_gem_cache
docker network rm ${app}_default

cd ${roro}

sudo rm -rf ${sandbox_dir}
mkdir -p ${sandbox_dir} 

dc build roro  

cd ${sandbox_dir} 

docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest roro rollon
  # -i handsomefencer/roro:latest printf "1\n1\n1\na\n" | roro rollon


schown  
dc build
dc run --rm app bundle 
dc up --build