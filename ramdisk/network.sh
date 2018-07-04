#!/bin/sh

set -x

# Start ssh daemon
INTERFACE=smc0

ifconfig $INTERFACE 2>&1 >/dev/null
if [ $? -ne 0 ]; then INTERFACE=dwc0; fi
ifconfig $INTERFACE 10.0.4.42 netmask 255.255.255.240
/usr/sbin/sshd

# Remount filesystem as rw
mount -o rw /

# Interfaces for VirtIO network and configure them
ifconfig tap0 create
ifconfig bridge create
ifconfig bridge0 addm tap0 addm $INTERFACE
ifconfig tap0 up
ifconfig bridge0 inet 10.0.4.86 netmask 255.255.255.240

ifconfig
