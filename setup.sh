#!/bin/bash

#########################################
## Only works for debian distributions ##
#########################################

# Check if /etc/os-release contains ID=debian or ID_LIKE includes debian
if grep -q 'ID=debian' /etc/os-release || grep -q 'ID_LIKE=.*debian' /etc/os-release; then
    echo "Debian-based distribution detected. Continuing..."
    # Place your script's main logic here

# Define some colors for styling
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Update system
echo -e "${BLUE} ===== Updating the System =====${NC}"
sudo apt update
sudo apt upgrade

# Programme Installieren
echo -e "${BLUE} ===== Installing Additional Programms =====${NC}"
sudo apt install btop vim ranger

echo -e "${BLUE} ===== Configuring Additional Programms =====${NC}"
cp /etc/vim/vimrc ~/.vimrc
echo -e "\n\" Relative line numbering \nset relativenumber \n \n\" Syntax Highlighting \nsyntax on" >> ~/.vimrc

# Docker prerequesites
echo -e "${BLUE} ===== Installing Docker Prerequesites =====${NC}"
# Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Get the Docker key
echo -e "${BLUE} ===== Signing the Docker Repository=====${NC}"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add the Docker repository to APT sources
sudo add-apt-repository "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Register the repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Check if the update runs without errors
echo -e "${BLUE} ===== Check if the repository works =====${NC}"
sudo apt update

# Make sure you install from the Docker repo instead of default Debian repo
apt-cache policy docker-ce

# Docker installation
echo -e "${BLUE} ===== Docker installation =====${NC}"
sudo apt install docker-ce

# Check if the deamon startet
echo -e "${BLUE} ===== Checking the deamon =====${NC}"
systemctl status docker

echo -e "${BLUE} ===== Installation Complete =====${NC}"

else
    echo "This script is intended for Debian-based systems."
    exit 1
fi
