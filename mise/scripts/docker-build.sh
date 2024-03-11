#!/bin/sh

dc build --no-cache ruby 
dc build --no-cache builder 
dc build --no-cache development 
dc build --no-cache test 

