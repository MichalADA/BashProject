#!/bin/bash
LOGFILE="/var/log/speedtest.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
speedtest-cli --simple >> $LOGFILE
echo "Test conducted at $DATE" >> $LOGFILE
