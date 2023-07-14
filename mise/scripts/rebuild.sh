#!/bin/bash

app='foobar'
sandbox_dir=~/sandbox/${app}
roro=~/work/handsomefencer/gems/roro


cd ${sandbox_dir} 
docker-compose down

# docker system prune
# docker volume rm ${app}_db_data
# docker volume rm ${app}_gem_cache
# docker network rm ${app}_default

cd ${roro}

sudo rm -rf ${sandbox_dir}
mkdir -p ${sandbox_dir} 

git add .

dc build prod

mkdir -p ${sandbox_dir}
cd ${sandbox_dir} 

docker rm artifact
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro-prod sh -c "printf '1\n3\n2\n2\na\n' | roro rollon"

schown  

dc build app 
dc up app


cd ${roro}
