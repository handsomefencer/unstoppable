#!/bin/sh

docker images
docker volume ls

docker images <%= @env[:base][:app_name][:value] %>/*


