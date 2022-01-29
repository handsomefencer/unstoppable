#!/bin/bash

cd $DST
sudo chown -R $USER:$USER .
<<<<<<< HEAD
docker-compose build --no-cache
=======
docker-compose build
<<<<<<< HEAD
#docker-compose run --rm app bin/rails webpacker:install
>>>>>>> stackr
=======
>>>>>>> rake-test-annotate
docker-compose up


