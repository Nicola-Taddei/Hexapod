
FROM ubuntu:22.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt update && apt install -y curl gnupg2 lsb-release
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y ros-humble-desktop

RUN apt install git-all

WORKDIR /root/dev_ws/src
RUN git clone https://github.com/ros/ros_tutorials.git -b humble
WORKDIR /root/dev_ws

RUN apt-get install python3-rosdep -y
RUN rosdep init
RUN rosdep update
RUN rosdep install -i --from-path src --rosdistro humble -y
RUN apt install python3-colcon-common-extensions -y
