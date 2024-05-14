#!/bin/bash
INTERFACE="eth0"
IP="192.168.1.100"
NETMASK="255.255.255.0"
GATEWAY="192.168.1.1"

ip addr add $IP/$NETMASK dev $INTERFACE
ip route add default via $GATEWAY
echo "nameserver 8.8.8.8" > /etc/resolv.conf
