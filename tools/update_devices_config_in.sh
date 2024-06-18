#!/bin/bash
config_in_content=''
for pkg in $(ls opt/external-packages)
do
	config_in_content+="\nsource \"../external-packages/${pkg}/Config.in\""
done

for dev in pi0 pi02w pi02w-dev pi0-dev pi2 pi2-dev pi4 pi4-dev
do
	echo -e -n "${config_in_content:2}" > opt/${dev}/Config.in
done
