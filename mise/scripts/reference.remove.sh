#!/bin/bash

cd ${sandbox_dir} 

docker compose --profile development down

cd ${roro}

sudo rm -rf ${sandbox_dir}
