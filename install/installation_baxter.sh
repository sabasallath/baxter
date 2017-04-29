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

# 1 # --- --- Install Ubuntu 14.05 --- --- #
#### Already done

# 2 # --- --- Install ROS --- --- #

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


# 3 # --- --- Create Baxter Development Workspace --- --- #
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


# 4 # --- --- Install Baxter SDK Dependencies --- --- #
# Install SDK Dependencies
color_echo "=== === Install SDK Dependencies === ==="
sudo apt-get update
sudo apt-get install -y git-core python-argparse python-wstool python-vcstools python-rosdep ros-indigo-control-msgs ros-indigo-joystick-drivers


# 5 # --- --- Install Baxter Research Robot SDK --- --- #
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

# 6 # --- --- Configure Baxter Communication/ROS Workspace --- --- #
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

## Initialize your SDK environment
color_echo "=== === Initialize your SDK environment === ==="
cd ~/ros_ws
. baxter.sh

# 7 # --- --- Verify Environment --- --- #
color_echo "=== === Verify Environment === ==="
env | grep ROS
### The important fields at this point:
### ROS_MASTER_URI - This should now contain your robot's hostname.
### ROS_IP - This should contain your workstation's IP address.
### or
### ROS_HOSTNAME - If not using the workstation's IP address, the ROS_HOSTNAME field should contain your PC's hostname. Otherwise, this field should not be available. 

# 8 # --- --- Configure Baxter Communication/ROS Workspace Again to use the physical robot --- --- #
color_echo "=== === Customize the baxter.sh if you don't want to only use the simulator === ==="
color_echo "Edit the 'baxter_hostname' field in baxter.sh script"
color_echo "Baxter's hostname is defaulted as the robot's serial number."
color_echo "The serial number can be located on the back of the robot, next to the power button."
color_echo "Specify Baxter's hostname"
color_echo "**baxter_hostname=\"baxter_hostname.local\"**"