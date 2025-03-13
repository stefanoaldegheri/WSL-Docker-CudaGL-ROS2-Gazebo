#!/bin/bash
set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing NVIDIA Container Toolkit..."
sudo apt install -y \
    libnvidia-container1 \
    libnvidia-container-tools \
    nvidia-container-toolkit-base \
    nvidia-container-toolkit \
    nvidia-docker2

echo "Installing OpenGL & Vulkan support..."
sudo apt install -y \
    libgl1-mesa-glx \
    libvulkan1 \
    mesa-vulkan-drivers \
    vulkan-tools

echo "Restarting WSL..."
wsl --shutdown
