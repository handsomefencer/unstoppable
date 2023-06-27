#!/bin/bash

## build roro image 
dc build roro  

## remove any previously greenfielded artifact 
docker rm artifact 

## recreate and change into greenfield directory
greenfield = '~/work/sandbox/greenfield'
sudo rm -rf greenfield
mkdir -p ${greenfield} 
cd ${greenfield} 

## run rollon 

docker run \
  --name artifact \
  -v $PWD:/artifact \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u 0 \
  -it handsomefencer/roro:latest roro rollon

schown  
dc build
dc run --rm app bundle 
dc up