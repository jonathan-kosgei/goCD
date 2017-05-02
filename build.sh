#!/bin/bash
###################
# Blue Deployment 
###################

# Login to the gitlab registry
sudo docker login --username $USERNAME --password $PASSWORD gitlab.mytestlab.xyz:4567

# Build a new nginx image with the new index.html
sudo docker build -t gitlab.mytestlab.xyz:4567/docker/images/blue-nginx docker/nginx

# Push new image to the gitlab registry
sudo docker push gitlab.mytestlab.xyz:4567/docker/images/blue-nginx

# Update deployment
kubectl apply -f kubernetes/deployments/blue-nginx.yml

# Update the image of the running blue nginx deployment
kubectl set image deployment/blue-nginx nginx=gitlab.mytestlab.xyz:4567/docker/images/blue-nginx:latest

# Update the proxy to proxy to the blue deployment
kubectl apply -f kubernetes/services/proxy.yml