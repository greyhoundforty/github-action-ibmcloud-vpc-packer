#!/usr/bin/env bash 

set -e
set -x

LOGFILE="/tmp/packer-installer.log"

echo -e "Hello from Packer template: `hostname -s`" | tee -a "$LOGFILE"


main() {
    echo -e "[:: Updating system packages ::]" 
    install_system_packages() {
        export NEEDRESTART_MODE=a
        export DEBIAN_FRONTEND=noninteractive
        export DEBIAN_PRIORITY=critical
        apt-get -qy clean
        apt-get -qy update
        apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
        apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install linux-headers-$(uname -r) curl wget apt-transport-https ca-certificates software-properties-common
    }

    install_system_packages

} 

main

