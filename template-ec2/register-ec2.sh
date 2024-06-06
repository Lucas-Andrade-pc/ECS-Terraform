#!/bin/bash

apt update -y
curl -O https://s3.us-east-1.amazonaws.com/amazon-ecs-agent-us-east-1/amazon-ecs-init-latest.amd64.deb
apt --fix-broken install -y
dpkg -i amazon-ecs-init-latest.amd64.deb
systemctl start docker.service
su <<EOF echo ECS_CLUSTER=cluster-demo >> /etc/ecs/ecs.config 
EOF
systemctl start ecs