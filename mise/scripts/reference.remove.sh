#!/bin/bash

# export app='reference-app'
# export sandbox_dir=~/sandbox/${app}
# export roro=~/work/handsomefencer/club/roro-stories-2204

cd ${sandbox_dir} 

docker compose down

cd ${roro}

sudo rm -rf ${sandbox_dir}
