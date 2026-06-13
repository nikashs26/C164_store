#!/bin/bash
set -e

sudo apt-get update -qq
sudo apt-get install -y docker.io
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker
