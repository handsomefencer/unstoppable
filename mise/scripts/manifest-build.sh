#!/bin/bash

# rm -rf mise/k8s/manifest/*.yaml
# kompose convert -f docker-compose.prod.yml -o mise/k8s/konvert
cp -r mise/k8s/manifest/app-service.yaml.tt mise/k8s/manifest/app-service.yaml
cp -r mise/k8s/manifest/app-deployment.yaml.tt mise/k8s/manifest/app-deployment.yaml
cp -r mise/k8s/manifest/sidekiq-deployment.yaml.tt mise/k8s/manifest/sidekiq-deployment.yaml

