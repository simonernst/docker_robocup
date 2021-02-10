FROM nvcr.io/nvidia/l4t-base:r32.3.1

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt update && apt upgrade -y &&\
    apt install -y libboost-dev libboost-all-dev

RUN apt install -y libgflags-dev \
    libgoogle-glog-dev\
    liblmdb-dev\
    libatlas-base-dev\
    liblmdb-dev libblas-dev\
    libatlas-base-dev\
    libprotobuf-dev\
    libleveldb-dev\
    libsnappy-dev\
    libhdf5-serial-dev\
    protobuf-compiler

RUN wget http://www.cmake.org/files/v3.12/cmake-3.12.2.tar.gz &&\
    tar -xvzf cmake-3.12.2.tar.gz &&\
    cd cmake-3.12.2/ &&\
    ./configure &&\
    make &&\
    make install



RUN git clone --recursive https://github.com/CMU-Perceptual-Computing-Lab/openpose &&\
    cd /openpose && git checkout 6d3ff8b336

RUN cd /openpose && mkdir build &&\
    cd build &&\
    cmake .. -DCUDA_ARCH_BIN=53 &&\
    make -j`nproc`
