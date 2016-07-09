#!/bin/sh

# PUSH
# scp chs8-probe.sh root@192.168.1.8:

# PULL
# scp root@192.168.1.8:last-chs8-assoc .

while true
do
echo -n "***Started: " > last-chs8-assoc
date >> last-chs8-assoc

wl -i wl0.1 assoclist >> last-chs8-assoc
wl -i wl0.2 assoclist >> last-chs8-assoc
wl -i wl0.3 assoclist >> last-chs8-assoc
wl -i wl1.1 assoclist >> last-chs8-assoc
wl -i wl1.2 assoclist >> last-chs8-assoc
wl -i wl1.3 assoclist >> last-chs8-assoc
 
wl -i wl0.1 assoc >> last-chs8-assoc
wl -i wl0.2 assoc >> last-chs8-assoc
wl -i wl0.3 assoc >> last-chs8-assoc
wl -i wl1.1 assoc >> last-chs8-assoc
wl -i wl1.2 assoc >> last-chs8-assoc
wl -i wl1.3 assoc >> last-chs8-assoc

cat last-chs2-assoc >> LOG-chs8-assoc

sleep 120
done
