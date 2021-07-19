#!/bin/bash --login

cd ../roro && rake build && rake install
roro --help
#printf 4 | roro roll_your_own
echo -e "4" | roro roll_your_own
