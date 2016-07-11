#!/bin/sh

# Add this to pi's crontab
# @daily /home/pi/src/chs-netmonitor/run-mysql-backup.sh


mkdir -p /home/pi/src/chs-netmonitor/mysqlbackups/
mysqldump -u root  ntopng > /home/pi/src/chs-netmonitor/mysqlbackups/$(date +%F)_full_myDB.sql

