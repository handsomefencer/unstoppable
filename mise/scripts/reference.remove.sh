#!/bin/bash

cd ${sandbox_dir} 

export COMPOSE_PROFILES=development,test,setup

cd ${roro}

sudo rm -rf ${sandbox_dir}
