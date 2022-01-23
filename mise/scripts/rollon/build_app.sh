#!/bin/bash

cd $DST
sudo chown -R $USER:$USER .
docker-compose build --no-cache
docker-compose up


