#!/bin/bash

mkdir -p ${sandbox_dir} 
cd ${sandbox_dir}  

docker rm artifact
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -e APP_NAME=${PWD} \
  -it roro/production sh -c "printf '4\n2\n2\na\n' | roro rollon"
  # -it handsomefencer/roro:latest roro rollon

schown .
cd ${roro}
