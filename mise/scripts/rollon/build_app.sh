#!/bin/bash

cd $DST
sudo chown -R $USER:$USER .
docker-compose build
#docker-compose run --rm app bin/rails webpacker:install
docker-compose up


