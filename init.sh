#!/usr/bin/env bash 

set -e
set -x

LOGFILE="/tmp/packer-installer.log"

echo -e "Hello from Packer template: `hostname -s`" | tee -a "$LOGFILE"

install_system_packages() {
    echo -e "[:: Updating system packages ::]"
    DEBIAN_FRONTEND=noninteractive apt-get -qqy update
    DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
    # echo -e "[:: Installing system dependencies ::]"
    # DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install unzip python3-pip git curl build-essential wget linux-headers-`uname -r`
} 

# install_ibm_tools() {
#     curl -sL http://ibm.biz/idt-installer | bash
#     python3 -m pip install softlayer
# } 

install_system_packages
# install_ibm_tools