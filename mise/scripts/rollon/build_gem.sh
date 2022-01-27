#!/bin/bash

cd $SRC
rm -rf pkg/*
rm roro-0*

docker-compose build


