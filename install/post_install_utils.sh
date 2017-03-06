#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export DEBIAN_FRONTEND=noninteractive

# Ubuntu Make
sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make -y
sudo apt-get update
sudo apt-get install ubuntu-make -y

# Visual Studio Code

umake ide visual-studio-code
umake ide pycharm
