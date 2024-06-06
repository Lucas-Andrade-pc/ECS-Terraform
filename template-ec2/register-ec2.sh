#!/bin/bash

sudo apt update -y
sudo curl -O https://s3.us-east-1.amazonaws.com/amazon-ecs-agent-us-east-1/amazon-ecs-init-latest.amd64.deb
sudo apt --fix-broken install -y
sudo dpkg -i amazon-ecs-init-latest.amd64.deb
sudo systemctl start docker.service
echo ECS_CLUSTER=cluster-demo  | sudo tee /etc/ecs/ecs.config 
sudo systemctl start ecs