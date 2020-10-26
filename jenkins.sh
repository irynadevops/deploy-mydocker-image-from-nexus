#! /bin/bash

#if 
#kubectl rollout undo deployment/docker
kubectl apply -f docker-deploy.yaml --env=BUILD_NUMBER=$1


