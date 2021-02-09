FROM nvidia/cuda:10.2-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive 


RUN echo "Installing dependencies..." && \
	apt-get -y --no-install-recommends update && \
    apt install -y tzdata &&\
	apt-get -y --no-install-recommends upgrade && \
	apt-get install -y --no-install-recommends \
	build-essential \
	cmake \
	git \
	libatlas-base-dev \
	libprotobuf-dev \
	libleveldb-dev \
	libsnappy-dev \
	libhdf5-serial-dev \
	protobuf-compiler \
	libboost-all-dev \
	libgflags-dev \
	libgoogle-glog-dev \
	liblmdb-dev \
	pciutils \
	python3-setuptools \
	python3-dev \
	python3-pip \
	opencl-headers \
	ocl-icd-opencl-dev \
	libviennacl-dev \
	libcanberra-gtk-module \
	libopencv-dev

RUN apt install wget

RUN wget http://www.cmake.org/files/v3.12/cmake-3.12.2.tar.gz &&\
    tar -xvzf cmake-3.12.2.tar.gz &&\
    cd cmake-3.12.2/ &&\
    ./configure &&\
    make -j8 &&\
    make install



RUN python3 -m pip install pip --upgrade

RUN python3 -m pip install\
	numpy \
	protobuf \
	opencv-python

COPY libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb .
COPY libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb .
COPY libcudnn7-doc_7.6.5.32-1+cuda10.2_amd64.deb .

RUN dpkg -i libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb 
RUN dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb
RUN dpkg -i libcudnn7-doc_7.6.5.32-1+cuda10.2_amd64.deb

RUN echo "Downloading and building OpenPose..." && \
	git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git && \
    cd /openpose && git checkout 6d3ff8b336
	
RUN mkdir -p /openpose/build &&\
    cd /openpose/build && \
	cmake ..

RUN rm libcudnn7*



# -----------------Fix for SM 70 & 75-------------------

# Fix for SM 70 & 75 in the old version of Caffe
# due to Openpose 1.4.0 branch

# If you have one of the following GPU, it may helps:
# -Titan V, Tesla V100
# -GTX 1660Ti, RTX 2060/2070/2080, Titan RTX
# -Quadro RTX 4000/5000/6000/8000/T1000/T2000/Telsa T4

# Else, if you have a newer one SM 80 or 86, it will stil 
# an issue

# Otherwise, all older GPU should be supported

ADD Cuda.cmake /openpose/3rdparty/caffe/cmake/Cuda.cmake
# --------------------------------------------------------






RUN cd /openpose/build && \
    make -j`nproc`

ENV OPENPOSE_HOME=/openpose

WORKDIR /openpose
ENTRYPOINT [ "bash" ]