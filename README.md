# Docker_robocup

## Presentation
Deploy the [robocup-main](https://github.com/Robocup-Lyontech/robocup-main) repository with Docker.

## Docker openpose

Dockerfile for building Openpose v1.4.0 

## Docker robocup

Dockerfile for building robocup-main (on branch dev_palbator_melodic)

## Installation

```bash
git clone https://github.com/simonernst/docker_robocup
```

### To build openpose

Before starting the installation, you will need to have a Nvidia Developer Account and be logged in before downloading the files.

Download links for CuDNN 7.6.5 running along CUDA 10.2 : 

[libcudnn7.6.5-cuda10.2](https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/Ubuntu18_04-x64/libcudnn7_7.6.5.32-1%2Bcuda10.2_amd64.deb)

[libcudnn7.6.5-dev-cuda10.2](https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/Ubuntu18_04-x64/libcudnn7-dev_7.6.5.32-1%2Bcuda10.2_amd64.deb)

[libcudnn7.6.5-doc-cuda10.2](https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.5.32/Production/10.2_20191118/Ubuntu18_04-x64/libcudnn7-doc_7.6.5.32-1%2Bcuda10.2_amd64.deb)

*Download and place the previous files in the docker_openpose folder.*

Then, From this directory :
```bash
docker build -t openpose:latest .
```

#### Run
If you want to run openpose with the newly created image, use: 
```bash
docker run --gpus all -e DISPLAY=host.docker.internal:0.0 -e LIBGL_ALWAYS_INDIRECT=0 -it openpose:latest
```

### To build robocup-main

1. Add openpose to a local docker registry
    * Add a local registry: `docker run -d -p 6000:5000 --restart always --name registry registry:2`
    * Change the tag of openpose: `docker tag openpose:latest localhost:6000/openpose:latest`
    * Push openpose to the local registry: `docker push localhost:6000/openpose:latest`

2. Build robocup-main
    * `docker build -t robocup:latest .` 
  
  
#### Run instructions

TODO
