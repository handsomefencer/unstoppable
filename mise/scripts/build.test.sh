#!/bin/sh

docker compose down 

docker compose build --with-dependencies development
