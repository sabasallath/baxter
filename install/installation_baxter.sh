#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND=noninteractive

# Install ROS Indigo
## Setup your sources.list
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
## Setup your keys
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
## Verify Latest Debians
sudo apt-get update
## Install ROS Indigo Desktop Full
sudo apt-get install -y ros-indigo-desktop-full
## Initialize rosdep
sudo rosdep init
rosdep update
## Install rosinstall
sudo apt-get install -y python-rosinstall

# Create Baxter Development Workspace
## Create ROS Workspace
mkdir -p ~/ros_ws/src
## Source ROS Setup
source /opt/ros/indigo/setup.bash
cd ~/ros_ws
catkin_make
catkin_make install

# Install Baxter SDK Dependencies
sudo apt-get update
sudo apt-get install -y git-core python-argparse python-wstool python-vcstools python-rosdep ros-indigo-control-msgs ros-indigo-joystick-drivers

# Install Baxter Research Robot SDK
## Install Baxter SDK
cd ~/ros_ws/src
wstool init .
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
wstool update
## Source ROS Setup 
source /opt/ros/indigo/setup.bash
## Build and Install
cd ~/ros_ws
catkin_make
catkin_make install

