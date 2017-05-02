#!/bin/bash
###################
# Green Deployment 
###################

# Login to the gitlab registry
sudo docker login --username $USERNAME --password $PASSWORD gitlab.mytestlab.xyz:4567

# Build a new nginx image with the new index.html
sudo docker build -t gitlab.mytestlab.xyz:4567/docker/images/green-nginx docker/nginx

# Push new image to the gitlab registry
sudo docker push gitlab.mytestlab.xyz:4567/docker/images/green-nginx

# Update deployment
kubectl apply -f kubernetes/deployments/green-nginx.yml

# Update the image of the running green nginx deployment
kubectl set image deployment/green-nginx nginx=gitlab.mytestlab.xyz:4567/docker/images/green-nginx:latest

# Update the proxy to proxy to the green deployment
kubectl apply -f kubernetes/services/proxy.yml