#!/bin/bash


rollon=2\\n4

circleci config process .circleci/config.yml > process.yml

circleci local execute -c process.yml --job test-rollon-${rollon}-linux
