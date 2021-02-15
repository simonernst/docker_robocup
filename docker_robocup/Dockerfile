FROM nvidia/cuda:10.2-devel-ubuntu18.04 as cuda

FROM localhost:5000/openpose:latest as openpose

FROM ros:melodic

# Install all dependencies required 
RUN apt update && apt install -y \
    automake \
    build-essential \
    curl \
    doxygen \
    gcc \
    git \
    graphviz \
    libasound2-dev \
    libboost-filesystem-dev \
    libboost-python-dev  \
    libboost-system-dev \
    libboost-thread-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libicu-dev \
    libopencv-dev \
    libpcre2-dev \
    libpulse-dev \
    libtool \
    make \
    pkg-config \
    portaudio19-dev \
    python \
    python-all-dev \
    python-catkin-tools \
    python-dev \
    python-eventlet \
    python-gobject \
    python-gtk2 \
    python-opencv \
    python-pip \
    python-rosdep \
    python-setuptools \
    python-sphinx  \
    python3-all-dev \
    python3-dev \
    python3-pip \
    swig \
    unzip \
    wget 

# Install all ROS dependencies
RUN apt update && apt install -y \
    ros-${ROS_DISTRO}-amcl \
    ros-${ROS_DISTRO}-backward-ros \
    ros-${ROS_DISTRO}-camera-info-manager \
    ros-${ROS_DISTRO}-camera-info-manager-py \    
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-costmap-2d \
    ros-${ROS_DISTRO}-driver-base \
    ros-${ROS_DISTRO}-four-wheel-steering-msgs \
    ros-${ROS_DISTRO}-gazebo* \
    ros-${ROS_DISTRO}-laser-filters \
    ros-${ROS_DISTRO}-map-server \
    ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-move-base-msgs \
    ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-object-recognition-msgs \
    ros-${ROS_DISTRO}-octomap \
    ros-${ROS_DISTRO}-octomap-msgs \
    ros-${ROS_DISTRO}-openslam-gmapping \
    ros-${ROS_DISTRO}-pcl-conversions \
    ros-${ROS_DISTRO}-teb-local-planner \
    ros-${ROS_DISTRO}-pcl-* \
    ros-${ROS_DISTRO}-people-msgs \
    ros-${ROS_DISTRO}-resource-retriever* \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-ros-numpy \
    ros-${ROS_DISTRO}-rosbridge-suite \
    ros-${ROS_DISTRO}-roslint \
    ros-${ROS_DISTRO}-rospy-message-converter \
    ros-${ROS_DISTRO}-urdf-geometry-parser \
    ros-${ROS_DISTRO}-twist-mux \
    ros-${ROS_DISTRO}-vision-opencv \
    ros-${ROS_DISTRO}-xacro

# Install all pip dependencies
RUN python -m pip install pip --upgrade
RUN pip install flask flask-socketio==4.3.2 flask-cors socketIO-client pyttsx3 pyaudio pocketsphinx shapely
# Fix for HriManager due to API change in Python-EngineIO
RUN pip install 'python-engineio<3.14' --upgrade 


# COPY Cuda libraries 
COPY --from=cuda /usr/local/cuda-10.2 /usr/local/cuda-10.2
COPY --from=cuda /usr/include /usr/include
COPY --from=cuda /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
RUN ln -s /usr/local/cuda-10.2 /usr/local/cuda
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/targets/x86_64-linux/lib:${LD_LIBRARY_PATH}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs:${LIBRARY_PATH}
ENV LIBRARY_PATH /usr/local/cuda/lib64/:${LIBRARY_PATH}
ENV NVIDIA_VISIBLE_DEVICES=all

#Install Mimic TTS
WORKDIR /mimic
RUN git clone https://github.com/MycroftAI/mimic1.git --depth=1 -b master . &&\
    sh ./dependencies.sh --prefix="/opt/mimic/install" &&\
    sh ./autogen.sh &&\
    sh ./configure --prefix="/opt/mimic/install" &&\
    make -j`nproc` && make check && make install &&\
    cd / && rm -rf /mimic


#Clone the robocup repo
WORKDIR /root/catkin_ws/src
RUN mkdir -p /root/catkin_ws/src &&\
    cd /root/catkin_ws/src &&\
    git clone --recursive https://www.github.com/Robocup-Lyontech/robocup-main -b dev_palbator_melodic


WORKDIR /root/catkin_ws

#COPY Openpose from another docker Image 
COPY --from=openpose /openpose /openpose
ENV OPENPOSE_HOME=/openpose

#Add libcudnn from local folder
COPY libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb .
COPY libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb .
COPY libcudnn7-doc_7.6.5.32-1+cuda10.2_amd64.deb .
#Extract libcudnn 
RUN dpkg -i libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb 
RUN dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb
RUN dpkg -i libcudnn7-doc_7.6.5.32-1+cuda10.2_amd64.deb
RUN rm libcudnn7*


#Compiling the robocup repo
RUN . /opt/ros/${ROS_DISTRO}/setup.sh &&\
     catkin build openpose_ros_msgs  &&\
     catkin build darknet_ros_msgs &&\
     catkin build openpose_ros_srvs &&\
     catkin build robocup_msgs &&\
     catkin build convert_2d_to_3d &&\
     catkin build

#Tablet Palbator installation
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - &&\
    apt install nodejs -y

RUN cd src/robocup-main/robocup_palbator-hri_js && npm install

#For the simulation
RUN cd src/ &&\
    . /opt/ros/${ROS_DISTRO}/setup.sh &&\
    git clone -b melodic-devel https://github.com/Robocup-Lyontech/Palbator_simulation &&\
    cd .. &&\
    rosdep install --from-paths src --ignore-src --rosdistro melodic --skip-keys "pal_gazebo_plugins speed_limit_node sensor_to_cloud pmb2_rgbd_sensors pal_vo_server pal_karto pal_usb_utils pal_local_planner pal_filters hokuyo_node rrbot_launch robot_pose pal_pcl rviz_plugin_covariance pal-orbbec-openni2 slam_toolbox" -y &&\
    catkin build



#Add map files for the ycb world (simulation gazebo)
ADD ycb /root/.pal/pmb2_maps/configurations/ycb/



#Get darknet specific files for YCB objects detection with darknet ros (from ycb lyontech google drive)
RUN cd /root/catkin_ws/src/robocup-main/darknet_ros/darknet_ros/yolo_network_config/weights &&\
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Yroih50UpGGcPPjbN8Cd14L7mLuVW8_o' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Yroih50UpGGcPPjbN8Cd14L7mLuVW8_o" -O yolov3-ycb.weights && rm -rf /tmp/cookies.txt &&\
    cd /root/catkin_ws/src/robocup-main/darknet_ros/darknet_ros/config/ &&\
    wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1mUeoRboNpTQHK0OlFEFKwFtSbpknZiHD' -O yolov3-ycb.yaml &&\
    cd /root/catkin_ws/src/robocup-main/darknet_ros/darknet_ros/yolo_network_config/cfg &&\
    wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1qfNTCnPCR0HiaOu_kE7PP3GoKpCplMhg' -O yolov3-ycb.cfg

COPY darknet/darknet_ros_ycb.launch /root/catkin_ws/src/robocup-main/darknet_ros/darknet_ros/launch/darknet_ros_ycb.launch

#Expose following ports to network host
EXPOSE 3000 9090 1234 11311
WORKDIR /root/catkin_ws/src/robocup-main/robocup_palbator-hri_js

COPY ./npm.sh .
RUN chmod 777 npm.sh
#Start the HRI 
ENTRYPOINT ["bash","npm.sh"]


# - log is not a member of op (openpose_ros_node.cpp)
# - npm is not found (can't do npm install) but nodejs is installed. -> fixed, due to missing curl package

#gzweb : running but not with the map ...

#TODO : group all the different apt install packages
# add ARG simulation to install the simulation packages and dependencies


#Check tablet reactivity from Docker
#Change socketio port to another one (5000 is already taken)
#Regarder sur Wireshark ce qu'il se passe quand la tablette est refresh (tcp ????) -> sur docker rien ne se passe
#open ports 5000 sur docker




#Commands to run
# docker exec -it <name> bash

# source /opt/ros/melodic/setup.bash
# roslaunch rosbridge_server rosbridge_websocket.launch

#Launch palbator simulatio
# roslaunch pmb2_2dnav_gazebo pmb2_navigation.launch public_sim:=true world:=ycb gzclient:=false rviz:=false


#Issues:
# - no camera rendering as we are running the simulation headless (no OGRE rendering)


#gazebo debug 

# apt install gdb nano


#pb weights Darknet pas inclus dans darknet_ros