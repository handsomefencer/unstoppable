#!/bin/bash

cd ${sandbox_dir} 

docker compose stop dev
docker compose down

cd ${roro}

sudo rm -rf ${sandbox_dir}
