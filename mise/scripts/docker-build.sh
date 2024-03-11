#!/bin/sh

dc build ruby 
dc build builder 
dc build development 
dc build test 
dc build production 

dc run --rm dev roro rollon
