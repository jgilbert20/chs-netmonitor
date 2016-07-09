#!/bin/sh

# Push:
# scp -P 27182 chs2-probe.sh root@192.168.1.2:

# Pull
# scp -P 27182 root@192.168.1.2:last-chs2-assoc . 

while true
do
echo -n "***Started: " > last-chs2-assoc
date >> last-chs2-assoc
iw dev wlan1 station dump >> last-chs2-assoc
iw dev wlan0 station dump >> last-chs2-assoc

cat last-chs2-assoc >> LOG-chs2-assoc

sleep 120

done
