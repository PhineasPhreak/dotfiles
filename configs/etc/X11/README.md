## Driver Nvidia For Unix ([Kali Linux](https://docs.kali.org/general-use/install-nvidia-drivers-on-kali-linux), Ubuntu, ArchLinux)

Installer NVIDIA GPU et CUDA support sur les distributions Unix, ci-dessus:

*Note:* GPUs with a [CUDA Compute Capability](https://developer.nvidia.com/cuda-gpus) > 5.0 are recommended, but GPUs with less will still work.
```shell
apt update && apt dist-upgrade -y && reboot
```
Let’s determine the exact GPU installed, and check the kernel modules it’s using.
```shell
root@kali:~# lspci -v
```

### Installation
Once the system has rebooted, we will proceed to install the OpenCL ICD Loader, Drivers, and the CUDA toolkit.
```shell
apt install -y ocl-icd-libopencl1 nvidia-driver nvidia-cuda-toolkit
```

### Verify Driver Installation
Now that our system should be ready to go, we need to verify the drivers have been loaded correctly. We can quickly verify this by running the [nvidia-smi](https://developer.nvidia.com/nvidia-system-management-interface) tool.
```shell
root@kali:~# nvidia-smi 
```
With the output displaying our driver and GPU correctly, we can now dive into benchmarking.
Before we get too far ahead, let’s double check to make sure hashcat and CUDA are working together.
```shell
root@kali:~# hashcat -I
```
It appears everything is working, let’s go ahead and run a benchmark test.

### Benchmarking
```shell
root@kali:~# hashcat -b
```
There are a multitude of configurations to improve cracking speed, not mentioned in this guide. However, we encourage you to take a look at the [hashcat documentation](https://hashcat.net/wiki/) for your specific cases.

### Troubleshooting
In the event setup isn’t going as planned, we’ll install [clinfo](https://packages.debian.org/jessie/clinfo) for detailed troubleshooting information.
```shell
apt install -y clinfo
```

#### OpenCL Loaders
It may be necessary to check for additional packages that may be conflicting with our setup. Let’s first check to see what OpenCL Loader we have installed. The NVIDIA OpenCL Loader and the generic OpenCL Loader will both work for our system.
```shell
root@kali:~# dpkg -l |grep -i icd
```
If **mesa-opencl-icd** is installed run:
```shell
apt remove mesa-opencl-icd
```
Since we have determined that we have a compatible ICD loader installed, we can easily determine which loader is currently being used.
```shell
root@kali:~# clinfo | grep -i "icd loader"
```
As expected, our setup is using the open source loader that was installed earlier. Now, let’s get some detailed information about the system.

#### Querying GPU Information
We’ll use nvidia-smi once again, but with a much more verbose output.
```shell
root@kali:~# nvidia-smi -i 0 -q
```
It looks like our GPU is being recognized correctly, so let’s use glxinfo to determine if 3D Rendering is enabled.
```shell
root@kali:~# glxinfo | grep -i "direct rendering"
direct rendering: Yes
```
The combination of these tools should assist the troubleshooting process greatly. If you still experience issues, we recommend searching for similar setups and any nuances that may affect your specific system.
