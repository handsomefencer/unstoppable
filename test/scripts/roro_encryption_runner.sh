#!/bin/bash --login

bundle 
rake install 
# sudo rm -rf ../sandbox/roro
mkdir -p ../sandbox/roro/containers/app
mkdir -p ../sandbox/roro/keys
mkdir -p ../sandbox/roro/containers/database
# rm ../sandbox/roro/containers/backend/smart.smart.env
# rm ../sandbox/roro/containers/database/dummy.subenv.smart.env
# cp test/fixtures/files/dummy_env ../sandbox/roro/containers/database/smart.subenv.smart.env

(cd ../sandbox && \
  
  # roro generate::keys
  roro generate::exposed
)