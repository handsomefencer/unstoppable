#!/bin/bash --login

cd ../roro && rake build && rake install
roro --help
