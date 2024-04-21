#!/bin/bash

THRESHOLD=80

Email="admin@example.com"

disk_usage=$(df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }')

while IFS= read -r line; do
    usage_percent=$(echo $line | awk '{ print $1 }' | sed 's/%//')
    filesystem=$(echo $line | awk '{ print $2 }')

    if [ $usage_percent -ge $THRESHOLD ]; then
        subject="Uwaga wykorzystanie dysku na $(hostname)"
        message="Wykorzystanie dysku na $filesystem przekroczyło $THRESHOLD%. Wykorzystanie dysku to $usage_percent%."

        echo "$message" | mail -s "$subject" $Email
    fi
done <<< "$disk_usage"

echo "Monitoring zakończony." >> monitoring.txt
