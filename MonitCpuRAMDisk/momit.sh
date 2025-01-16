#!/bin/bash

# Użycie CPU
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Użycie RAM
MEM=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

# Użycie Dysku (root)
DISK=$(df -h / | awk 'NR==2 {print $5}')



echo "Użycie Cpu: $CPU%, Uzycie Ramu $MEM%, Uzycie Dysku: $DISK"
