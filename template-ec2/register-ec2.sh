#!/bin/bash

apt update -y
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt install docker-ce -y
curl -O https://s3.us-east-1.amazonaws.com/amazon-ecs-agent-us-east-1/amazon-ecs-init-latest.amd64.deb
dpkg -i amazon-ecs-init-latest.amd64.deb
#apt --fix-broken install -y
systemctl status docker.service > docker-status.txt
echo ECS_CLUSTER=cluster-demo | tee /etc/ecs/ecs.config 
systemctl start ecs