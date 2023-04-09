#!/bin/env bash

# Install Git
sudo dnf install -y git

# Remove existing docker installations
sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

# Use convenience script to install docker
# https://docs.docker.com/engine/install/centos/#install-using-the-convenience-script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Clone demo app and cd to a folder with a compose.yaml
git clone https://github.com/docker/awesome-compose.git
cd awesome-compose/nginx-flask-mysql/ || exit 1

# Start docker engine with systemd
sudo systemctl start docker
# Let docker do the magic
sudo docker compose up