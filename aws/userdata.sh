#!/bin/bash
#
# Script to be included as "user data" in AWS instances. It will be run when creating a new instance.
#

# Prints for debugging
set -x
# Mount NVMe disk
mkfs -t xfs /dev/nvme1n1
mkdir /data
mount /dev/nvme1n1 /data
# Update nvidia drivers
wget -q "https://us.download.nvidia.com/tesla/535.129.03/NVIDIA-Linux-x86_64-535.129.03.run"
yum erase -y nvidia cuda
sh NVIDIA-Linux-x86_64-535.129.03.run --silent
rm NVIDIA-Linux-x86_64-535.129.03.run
# Install cuda-toolkit so that docker can use the GPU
yum update -y
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
yum-config-manager --disable amzn2-graphics  # Disable AWS repo because it contains outdated versions of libraries required by nvidia-container-toolkit
yum install -y nvidia-container-toolkit
# Install docker: use the external NVMe disk to store all docker information
amazon-linux-extras install -y docker
mkdir /data/docker
sed -i 's/"$/ -g \/data\/docker"/' /etc/sysconfig/docker
service docker start
# Run SD web UI, serving on port 80
docker run --gpus all --rm -p 80:7860 albarji/sd-webui:1.1.0
