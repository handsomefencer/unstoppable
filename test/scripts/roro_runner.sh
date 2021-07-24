#!/bin/bash --login

cd ../roro && rake build && rake install
roro --help
printf '3' | roro roll_your_own
