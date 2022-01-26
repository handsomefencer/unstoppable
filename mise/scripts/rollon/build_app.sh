#!/bin/bash

cd $DST
sudo chown -R $USER:$USER .
<<<<<<< HEAD
docker-compose build --no-cache
=======
docker-compose build
#docker-compose run --rm app bin/rails webpacker:install
>>>>>>> stackr
docker-compose up


