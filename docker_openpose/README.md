
## Docker Openpose

### Presentation

It downloads and installs all dependencies required for Openpose 1.4.0

### Build instructions

Prior to the build, you must download and put in the directory docker_openpose all the .deb files for CUDNN.

**You will need to have a Nvidia Developer Account and be logged in before downloading the files.**

Download links for CuDNN 7.6.5 running along CUDA 10.2 : 
https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/Ubuntu18_04-x64/libcudnn7_7.6.5.32-1%2Bcuda10.2_amd64.deb
https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/Ubuntu18_04-x64/libcudnn7-dev_7.6.5.32-1%2Bcuda10.2_amd64.deb
https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/Ubuntu18_04-x64/libcudnn7-doc_7.6.5.32-1%2Bcuda10.2_amd64.deb


From this directory :
```bash
docker build -t openpose:latest .
```

### Run instructions

```bash
docker run --gpus all -e DISPLAY=host.docker.internal:0.0 -e LIBGL_ALWAYS_INDIRECT=0 -it openpose:latest
```

