#!/bin/bash

app='vite_foobar'
sandbox_dir=~/sandbox/${app}
roro=~/work/handsomefencer/gems/roro


cd ${sandbox_dir} 
docker-compose down
docker volume rm $(docker volume ls -q)
cd ${roro}

sudo rm -rf ${sandbox_dir}
mkdir -p ${sandbox_dir} 

git add .

# dc build --no-cache dev
dc build roro

mkdir -p ${sandbox_dir}
cd ${sandbox_dir} 
docker volume rm $(docker volume ls --filter name=$app -q)

docker rm artifact
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro sh -c "printf '2\n1\n2\n3\n2\n2\n1\na\n' | roro rollon"
  # -it handsomefencer/roro roro rollon
# 2\n1\n2\n3\n2\n2\n2\n1\na\n
schown  

dc build app 
dc up -d app
dc run --rm app bin/rails db:migrate
dc exec app ./bin/dev
# cd ${roro}
