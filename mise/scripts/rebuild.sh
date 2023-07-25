#!/bin/bash

app='foobar'
sandbox_dir=~/sandbox/${app}
roro=~/work/handsomefencer/gems/roro


cd ${sandbox_dir} 
docker-compose down

cd ${roro}

sudo rm -rf ${sandbox_dir}
mkdir -p ${sandbox_dir} 

git add .

# dc build --no-cache dev
dc build roro

mkdir -p ${sandbox_dir}
cd ${sandbox_dir} 

docker rm artifact
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro sh -c "printf '2\n1\n3\n2\n1\n2\n2\n2\na\n' | roro rollon"
  # -it handsomefencer/roro roro rollon

schown  

dc build app 
dc up app

# cd ${roro}
