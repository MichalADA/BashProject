#!/bin/bash
INTERFACE="eth0"
LOGFILE="/var/log/network_usage.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

RX=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
TX=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

echo "$DATE - RX: $RX bytes, TX: $TX bytes" >> $LOGFILE
