#!/bin/bash
HOSTS=("8.8.8.8" "8.8.4.4" "192.168.1.1")
LOGFILE="/var/log/ping_monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

for HOST in "${HOSTS[@]}"
do
    ping -c 1 $HOST > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$DATE - Host $HOST is down" >> $LOGFILE
        # Send email or SMS notification
    else
        echo "$DATE - Host $HOST is up" >> $LOGFILE
    fi
done
