#!/bin/sh
ip link set lo up
ip link show lo
echo '---'
sleep 20
dmesg | grep -i network
echo '---'
ip link set lo up
ip addr add 127.0.0.1/8 dev lo

# TODO: 2024-07-15, can be removed the day XmrSigner will be installed as buildroot package
cd /opt/src/

#/usr/bin/python3 main.py >> /dev/kmsg 2>&1 &  # version that writes output to dmesg
/usr/bin/python3 -m xmrsigner &
