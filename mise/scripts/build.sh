#!/bin/sh

dc build --no-cache --with-dependencies development 

dc up -d --build dev 

dc run --rm dev roro rollon
