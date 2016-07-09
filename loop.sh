#!/bin/sh

# Push:
# scp -P 27182 chs2-probe.sh root@192.168.1.2:

# Pull
# scp -P 27182 root@192.168.1.2:last-chs2-assoc . 

while true
do

sh ./runall.sh

sleep 600

done
