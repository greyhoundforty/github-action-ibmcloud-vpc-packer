#!/usr/bin/env bash 

set -e
set -x

LOGFILE="/tmp/packer-installer.log"

echo -e "Hello from Packer template: `hostname -s`" | tee -a "$LOGFILE"

install_system_packages() {
    echo -e "[:: Updating system packages ::]"
    DEBIAN_FRONTEND=noninteractive apt-get -qqy update
    DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
} 

install_system_packages