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
  -it handsomefencer/roro:latest roro rollon
  # -it handsomefencer/roro sh -c "printf '2\n4\n3\n1\na\n' | roro rollon"
  # -it handsomefencer/roro sh -c "printf '3\n4\n3\n1\na\n' | roro rollon"

schown .
cd ${roro}
