#!/bin/sh
ip link set lo up

# TODO: 2024-07-15, can be removed the day XmrSigner will be installed as buildroot package
cd /opt/src/

#/usr/bin/python3 main.py >> /dev/kmsg 2>&1 &  # version that writes output to dmesg
/usr/bin/python3 -m xmrsigner &
