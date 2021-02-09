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

ADD Cuda.cmake /openpose/3rdparty/caffe/cmake/Cuda.cmake

RUN cd /openpose/build && \
    make -j`nproc`

ENV OPENPOSE_HOME=/openpose

WORKDIR /openpose


# FROM ros:melodic


# RUN apt-get update && apt install -y \
# 	python-catkin-tools \
# 	ros-${ROS_DISTRO}-cv-bridge \
# 	ros-${ROS_DISTRO}-vision-opencv \
# 	ros-melodic-image-transport

# RUN mkdir -p /root/catkin_ws/src && \
# 	cd /root/catkin_ws/src &&\
# 	git clone https://github.com/jacques-saraydaryan/ros-openpose &&\
# 	git clone https://github.com/m0rph03nix/ros_openpose_gossip

# RUN cd /root/catkin_ws/ &&\
# 	. /opt/ros/${ROS_DISTRO}/setup.sh &&\
# 	catkin build openpose_ros_msgs  &&\
# 	catkin build openpose_ros_srvs &&\
# 	catkin build





ENTRYPOINT [ "bash" ]