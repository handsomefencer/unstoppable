#!/bin/sh

dc build ruby 
dc build --no-cache builder 
dc build --no-cache development 
dc build --no-cache dev

