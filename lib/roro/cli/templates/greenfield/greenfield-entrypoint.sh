#!/usr/bin/env bash

file="config/database.yml.example"
if [ -f "$file" ]
then
  exec mv -f config/database.yml.example config/database.yml && echo "shell script exists"
fi
if [ ! -f "$file" ]
then
  echo "shell script does not exist"
fi
