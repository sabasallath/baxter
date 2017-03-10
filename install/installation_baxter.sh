#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND=noninteractive

#############################################
## A ## === === Robot Installation === === ##
#############################################

# A1 # --- --- Install Ubuntu 14.05 --- --- #

# A2 # --- --- Install ROS --- --- #
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


# A3 # --- --- Create Baxter Development Workspace --- --- #
# Create ROS Workspace
mkdir -p ~/ros_ws/src
# Source ROS and Build
## Source ROS Setup
source /opt/ros/indigo/setup.bash
## Build and Install
cd ~/ros_ws
catkin_make
catkin_make install


# 4 # --- --- Install Baxter SDK Dependencies --- --- #
# Install SDK Dependencies
sudo apt-get update
sudo apt-get install -y git-core python-argparse python-wstool python-vcstools python-rosdep ros-indigo-control-msgs ros-indigo-joystick-drivers


# A5 # --- --- Install Baxter Research Robot SDK --- --- #
# Install Baxter SDK
cd ~/ros_ws/src
wstool init .
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
wstool update
# Source ROS Setup 
source /opt/ros/indigo/setup.bash
# Build and Install
cd ~/ros_ws
catkin_make
catkin_make install

# A6 # --- --- Configure Baxter Communication/ROS Workspace --- --- #
# Download the baxter.sh script
wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
chmod u+x baxter.sh

# Customize the baxter.sh script
## Edit the 'baxter_hostname' field
### Baxter's hostname is defaulted as the robot's serial number. The serial number can be located on the back of the robot, next to the power button.
###  Specify Baxter's hostname
### **baxter_hostname="baxter_hostname.local"**

## Edit the 'your_ip' field
### Modify where 'your_ip' is the IP address of your PC.
### **your_ip="192.168.XXX.XXX"**

## Verify 'ros_version' field
### Verify that the the 'ros_version' field matches the ROS version you are running:
### This field will default to "indigo"
### ***ros_version="indigo"***

## Save and Close baxter.sh script

## Initialize your SDK environment
### cd ~/ros_ws
### . baxter.sh

# A7 # --- --- Verify Environment --- --- #
env | grep ROS
### The important fields at this point:
### ROS_MASTER_URI - This should now contain your robot's hostname.
### ROS_IP - This should contain your workstation's IP address.
### or
### ROS_HOSTNAME - If not using the workstation's IP address, the ROS_HOSTNAME field should contain your PC's hostname. Otherwise, this field should not be available. 

#################################################
## B ## === === Simulator Installation === === ##
#################################################

# B1 # --- --- Prerequisites --- --- #

sudo apt-get install -y gazebo2 ros-indigo-qt-build ros-indigo-driver-common ros-indigo-gazebo-ros-control ros-indigo-gazebo-ros-pkgs ros-indigo-ros-control ros-indigo-control-toolbox ros-indigo-realtime-tools ros-indigo-ros-controllers ros-indigo-xacro python-wstool ros-indigo-tf-conversions ros-indigo-kdl-parser

# B2 # --- --- Baxter Simulator Installation --- --- #
# Install baxter_simulator
cd ~/ros_ws/src
# Already done in A
# wstool init .
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/master/baxter_simulator.rosinstall
wstool update

# Build Source
source /opt/ros/indigo/setup.bash
cd ~/ros_ws
catkin_make
catkin_make install

## Use baxter.sh - it has a special hook for sim:
cp src/baxter/baxter.sh .

## Edit the your_ip value in baxter.sh