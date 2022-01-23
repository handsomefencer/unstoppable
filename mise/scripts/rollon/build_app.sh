#!/bin/bash

cd $DST
docker-compose build --no-cache
sudo chown -R $USER:$USER .
docker-compose run --rm app bin/rails webpacker:install


