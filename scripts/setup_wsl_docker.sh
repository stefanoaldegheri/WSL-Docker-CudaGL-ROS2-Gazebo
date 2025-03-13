#!/bin/bash
set -e

echo "Checking WSL version..."
wsl --set-default-version 2
wsl --list --verbose

echo "Setting Ubuntu 22.04 as default WSL distribution..."
wsl --install -d Ubuntu-22.04 || echo "Ubuntu 22.04 is already installed."
wsl --set-default Ubuntu-22.04

echo "Configuring Docker Desktop for WSL..."
wsl --shutdown
echo "WSL configuration is complete. Restart Docker Desktop."
