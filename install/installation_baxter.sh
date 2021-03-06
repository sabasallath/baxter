#!/bin/bash

# Script safe mode
set -euo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND=noninteractive

# Display progress
GREEN=`tput setaf 2`
RESET=`tput sgr0`

function color_echo {
    echo "${GREEN}$1${RESET}"
}

#############################################
## A ## === === Robot Installation === === ##
#############################################

# A1 # --- --- Install Ubuntu 14.05 --- --- #

# A2 # --- --- Install ROS --- --- #
# Install ROS Indigo
## Setup your sources.list
color_echo "=== === Setup your sources.list === ==="
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
## Setup your keys
color_echo "=== === Setup your keys === ==="
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
## Verify Latest Debians
color_echo "=== === Verify Latest Debians === ==="
sudo apt-get update
## Install ROS Indigo Desktop Full
color_echo "=== === Install ROS Indigo Desktop Full === ==="
sudo apt-get install -y ros-indigo-desktop-full
## Initialize rosdep
color_echo "=== === Initialize rosdep === ==="
sudo rosdep init
rosdep update
## Install rosinstall
color_echo "=== === Install rosinstall === ==="
sudo apt-get install -y python-rosinstall


# A3 # --- --- Create Baxter Development Workspace --- --- #
# Create ROS Workspace
color_echo "=== === Create ROS Workspace === ==="
mkdir -p ~/ros_ws/src
# Source ROS and Build
## Source ROS Setup
color_echo "=== === Source ROS Setup === ==="
### Due to TMPDIR unset variable in /opt/ros/indigo/setup.bash, unset_variable as error is disabled
set +u
source /opt/ros/indigo/setup.bash
### unset_variable as error enabled
set -u
## Build and Install
color_echo "=== === Build and Install === ==="
cd ~/ros_ws
catkin_make
catkin_make install


# A4 # --- --- Install Baxter SDK Dependencies --- --- #
# Install SDK Dependencies
color_echo "=== === Install SDK Dependencies === ==="
sudo apt-get update
sudo apt-get install -y git-core python-argparse python-wstool python-vcstools python-rosdep ros-indigo-control-msgs ros-indigo-joystick-drivers


# A5 # --- --- Install Baxter Research Robot SDK --- --- #
# Install Baxter SDK
color_echo "=== === Install Baxter SDK === ==="
cd ~/ros_ws/src
wstool init .
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
wstool update
# Source ROS Setup
color_echo "=== === Source ROS Setup === ==="
### Due to TMPDIR unset variable in /opt/ros/indigo/setup.bash, unset_variable as error is disabled
set +u
source /opt/ros/indigo/setup.bash
### unset_variable as error enabled
set -u
# Build and Instal
color_echo "=== === Build and Instal === ==="
cd ~/ros_ws
catkin_make
catkin_make install

# A6 # --- --- Configure Baxter Communication/ROS Workspace --- --- #
# Download the baxter.sh script
color_echo "=== === Download the baxter.sh script === ==="
wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh

# Customize the baxter.sh if you don't want to only use the simulator
# /!\ Not done by the script -> manual edit baxter.sh

## Edit the 'your_ip' field
color_echo "=== === Edit the 'your_ip' field === ==="
### Modify where 'your_ip' is the IP address of your PC.
### **your_ip="192.168.XXX.XXX"**

### Create temporary file with new line in place
cat ~/ros_ws/baxter.sh | sed -e "s/your_ip=\"192.168.XXX.XXX\"/your_ip=\"localhost\"/" > ~/ros_ws/baxter_temp.sh
### Copy the new file over the original file
mv ~/ros_ws/baxter_temp.sh ~/ros_ws/baxter.sh
chmod u+x baxter.sh

## Verify 'ros_version' field
### Verify that the the 'ros_version' field matches the ROS version you are running:
### This field will default to "indigo"
### ***ros_version="indigo"***

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
set +u
source /opt/ros/indigo/setup.bash
set -u
cd ~/ros_ws
catkin_make
catkin_make install

## Use baxter.sh - it has a special hook for sim:
cp src/baxter/baxter.sh .

#################################################
## C ## === ===  Manual configuration  === === ##
#################################################

# C1 # --- --- Configure Baxter Communication/ROS Workspace Again to use the physical robot --- --- #
color_echo "=== === Customize the baxter.sh if you don't want to only use the simulator === ==="
color_echo "Edit the 'baxter_hostname' field in baxter.sh script"
color_echo "Baxter's hostname is defaulted as the robot's serial number."
color_echo "The serial number can be located on the back of the robot, next to the power button."
color_echo "Specify Baxter's hostname"
color_echo "**baxter_hostname=\"baxter_hostname.local\"**"
color_echo "If you only want to use the simulator, you're done"
echo

# C2 # --- --- Verify Environment --- --- #
color_echo "=== === Verify your Environment with === ==="
color_echo "env | grep ROS"
color_echo "The important fields at this point:"
color_echo "ROS_MASTER_URI - This should now contain your robot's hostname. Initialized by this script to a fake hostname"
color_echo "ROS_IP - This should contain your workstation's IP address."
color_echo "or"
color_echo "ROS_HOSTNAME - If not using the workstation's IP address, the ROS_HOSTNAME field should contain your PC's hostname."
color_echo "Otherwise, this field should not be available."
echo

# C3 # --- --- Verify Environment --- --- #
color_echo "Initialize your SDK environment with './baxter.sh sim'"
