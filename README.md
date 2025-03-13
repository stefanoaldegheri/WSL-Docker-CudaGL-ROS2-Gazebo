# ROS 2 Iron + Gazebo Garden + CUDA in Docker (WSL2)

This repository provides a step-by-step guide to set up ROS 2 Iron Irwini with Gazebo Garden inside Docker on WSL2, with full NVIDIA GPU acceleration.

## Setup Instructions

### 1. Install Docker Desktop & WSL2
1. Install Docker Desktop from [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/).
2. Enable WSL2 backend in Docker Desktop settings.
3. Install Ubuntu 22.04 in WSL2:
   ```sh
   wsl --install -d Ubuntu-22.04
   ```

### 2. Ensure WSL and Docker Desktop Are Running
1. Open **PowerShell** and start WSL:
   ```sh
   wsl
   ```
2. Inside the WSL terminal, check that Docker is running:
   ```sh
   docker --version
   ```
   Expected output:
   ```
   Docker version X.XX.XX, build XXXXXXX
   ```
3. If Docker is not running, start Docker Desktop from Windows and retry.

### 3. Install NVIDIA GPU Drivers & Toolkit
Run the following inside WSL:
```sh
sudo apt update && sudo apt upgrade -y
bash scripts/install_nvidia_wsl.sh
```

### 4. Build & Run the Docker Container
```sh
cd docker
docker build -t ros2-iron-gazebo-gpu .
docker-compose up -d
```

### 5. Attach to the Running Container
```sh
docker attach ros2-gpu-container
```

## Verification Steps

### 1. Verify GPU Support
Inside the container, run:
```sh
nvidia-smi
glxinfo -B
```
Expected output:
- `nvidia-smi` should detect the GPU.
- `glxinfo -B` should show `OpenGL renderer string: NVIDIA`.

### 2. Launch Gazebo Garden with an Empty World
Start Gazebo inside the container:
```sh
source /opt/ros/iron/setup.bash
gz sim -s /usr/share/gz/gz-sim7/worlds/empty.sdf -r -v 4 & gz sim -g &
```
- The Gazebo GUI should open, displaying an empty simulation world.

### 3. Check if Gazebo is Running on the GPU
While Gazebo is open, run:
```sh
nvidia-smi
```
Expected output:
- The Gazebo process should be listed under GPU usage, confirming it's utilizing the NVIDIA GPU.

## Troubleshooting
Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.

## License
MIT License - see [LICENSE](LICENSE) for details.
