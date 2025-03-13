# 🛠 Troubleshooting

This document provides solutions to common issues encountered when setting up **ROS 2 Iron + Gazebo Garden + CUDA in Docker (WSL2)**.

---

## **1️⃣ `nvidia-smi` Not Detecting GPU Inside Docker**
### **Issue**
Running `nvidia-smi` inside the container returns:
```
Failed to initialize NVML: Driver/library version mismatch
```
or
```
NVIDIA-SMI has failed because it couldn’t communicate with the NVIDIA driver
```
### **Solution**
1. **Ensure NVIDIA drivers are installed on the host** (Windows):
   ```sh
   wsl --shutdown
   ````
   Then, update drivers from:
   - [NVIDIA CUDA for WSL](https://developer.nvidia.com/cuda/wsl)
   - Restart WSL and Docker Desktop.

2. **Ensure Docker has access to GPU:**
   ```sh
   docker run --rm --gpus all nvidia/cuda:12.2-base nvidia-smi
   ```
   - If this fails, reinstall `nvidia-container-toolkit` inside WSL:
     ```sh
     sudo apt update
     sudo apt install -y nvidia-container-toolkit
     ```

---

## **2️⃣ OpenGL Renderer is Not NVIDIA**
### **Issue**
Running `glxinfo -B` inside the container shows:
```
OpenGL renderer string: llvmpipe (LLVM 13.0.0, 256 bits)
```
instead of **NVIDIA**.

### **Solution**
1. Ensure `libgl1-mesa-glx` and Vulkan drivers are installed inside WSL:
   ```sh
   sudo apt install -y libgl1-mesa-glx libvulkan1 mesa-vulkan-drivers vulkan-tools
   ```
2. Restart WSL:
   ```sh
   wsl --shutdown
   ```
3. Verify again:
   ```sh
   glxinfo -B
   ```
   It should now show:
   ```
   OpenGL renderer string: NVIDIA
   ```

---

## **3️⃣ Gazebo GUI Does Not Appear**
### **Issue**
Running `gz sim -v 4` does not open the GUI.

### **Solution**
1. Ensure **WSLg** is enabled in WSL:
   ```sh
   echo $DISPLAY
   ```
   If empty, restart WSL:
   ```sh
   wsl --shutdown
   wsl
   ```
2. Ensure `docker-compose.yml` has the correct X11 and WSLg environment:
   ```yaml
   environment:
      - DISPLAY=${DISPLAY}
      - WAYLAND_DISPLAY=${WAYLAND_DISPLAY}
      - XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}
      - PULSE_SERVER=${PULSE_SERVER}
   volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - /mnt/wslg:/mnt/wslg
   ```

---

## **4️⃣ Gazebo is Not Using GPU (Not Visible in `nvidia-smi`)**
### **Issue**
Gazebo is running, but **`nvidia-smi` does not show it using the GPU**.

### **Solution**
1. Run Gazebo with Vulkan explicitly enabled:
   ```sh
   export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
   gz sim -v 4
   ```
2. Check `nvidia-smi` again in another terminal inside the container:
   ```sh
   nvidia-smi
   ```

---

## **5️⃣ `docker attach` Freezes the Terminal**
### **Issue**
After running `docker attach ros2-gpu-container`, **the terminal freezes** when running commands.

### **Solution**
1. Use **a new shell session** instead:
   ```sh
   docker exec -it ros2-gpu-container bash
   ```
2. Or, detach from the session properly:
   - Press: `Ctrl + P` then `Ctrl + Q`

---

For more advanced issues, check **Docker logs** with:
```sh
docker logs ros2-gpu-container
```

---

## ✅ **Need More Help?**
- Check the official **ROS 2** and **NVIDIA CUDA** documentation.
