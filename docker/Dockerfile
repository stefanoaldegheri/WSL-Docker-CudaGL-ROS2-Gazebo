# Use ROS 2 Iron as base (Ubuntu 22.04)
FROM osrf/ros:iron-desktop

# Install required packages
RUN apt update && apt install -y --no-install-recommends \
    gnupg2 ca-certificates curl

# Add NVIDIA repository key
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | apt-key add - 

# Add NVIDIA CUDA repository
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# Install CUDA toolkit and OpenGL libraries
RUN apt update && apt install -y \
    cuda-toolkit-12-2 \
    libglvnd-dev \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxext6 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Set NVIDIA runtime environment variables
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH
ENV MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
ENV LIBVA_DRIVER_NAME=d3d12

# Install additional OpenGL utilities
RUN apt update && apt install -y \
    mesa-utils \
    glmark2 \
    vulkan-tools \
    libglfw3-dev \
    libglew-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# X11/Wayland compatibility layers
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Set noninteractive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt upgrade -y && \
    apt install -y curl gnupg lsb-release software-properties-common

# Add Gazebo official repository
RUN curl -sSL https://packages.osrfoundation.org/gazebo.key | apt-key add - && \
    echo "deb [arch=amd64] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list && \
    apt update

# Install Gazebo Garden and ROS-Gazebo integration
RUN apt update && apt install -y \
    gz-garden \
    ros-iron-ros-gz \
    ros-iron-ros-gz-sim \
    ros-iron-ros-gz-bridge

# Set environment variables
RUN echo "source /opt/ros/iron/setup.bash" >> /root/.bashrc && \
    echo "export GZ_VERSION=garden" >> /root/.bashrc && \
    echo "export PATH=/usr/bin:\$PATH" >> /root/.bashrc && \
    echo "export IGN_GAZEBO_SYSTEM_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gz-garden-plugins" >> /root/.bashrc && \
    echo "export IGN_GAZEBO_RESOURCE_PATH=/usr/share/gz" >> /root/.bashrc
    
# Set working directory
WORKDIR /root

# Set entrypoint to Bash with ROS & Gazebo sourced
CMD ["/bin/bash", "-c", "source /root/.bashrc && bash"]
