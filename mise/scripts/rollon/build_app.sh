#!/bin/bash

cd $DST
sudo chown -R $USER:$USER .
docker-compose build
docker-compose up


