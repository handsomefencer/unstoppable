#!/bin/bash


cd ${sandbox_dir} 

dcd 

dc build 
dc run --rm app bin/rails db:create

cd ${roro}
