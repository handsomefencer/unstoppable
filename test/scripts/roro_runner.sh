#!/bin/bash --login

bundle 
rake install 
sudo rm -rf ../sandbox 
mkdir -p ../sandbox
(cd ../sandbox && \
  
  docker system prune -af --volumes
  roro greenfield
)