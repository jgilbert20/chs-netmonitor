#!/bin/sh

cd /home/pi/src/chs-netmonitor/
date >> routerwatch.txt
ping -w 5 -D 192.168.1.1 >> routerwatch.txt
ping -w 5 -D 10.0.1.1 >> routerwatch.txt
ping -w 5 -D 10.0.1.100 >> routerwatch.txt
curl -u admin:jaxston28x1m540 http://192.168.1.1/Status_Router.asp | grep -i cpu_temp >> routerwatch.txt
echo  >> routerwatch.txt
echo '+++'  >> routerwatch.txt
echo  >> routerwatch.txt


