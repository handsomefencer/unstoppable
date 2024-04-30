#!/bin/bash

mkdir -p ${sandbox_dir} 
cd ${sandbox_dir} 

docker rm artifact
docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest sh -c "printf '3\n1\n2\na\n' | roro rollon"
  # -it handsomefencer/roro:latest roro rollon


cd ${roro}
