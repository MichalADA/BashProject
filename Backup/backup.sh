#!/bin/bash

# Configuration file with a list of paths to backup
source_list="source_list"

# Destination directory for backups
backup_root="/mnt/backup"

# Log file path
log_file="/mnt/backup/logfile.log"

# Email address for sending notifications
email_address="admin@example.com"

# Function for logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $log_file
}

# Function for sending email
send_email() {
    subject=$1
    body=$2
    echo "$body" | mailx -s "$subject" "$email_address"
}

# Start logging
log "Backup process started."
send_email "Backup Process Started" "The backup process has started."

# Check if the source file exists
if [ ! -f $source_list ]; then
    message="The source list file does not exist: $source_list"
    log "$message"
    send_email "Backup Error" "$message"
    exit 1
fi

# Create backup for each path in the configuration file
while IFS= read -r source; do
    if [ -n "$source" ]; then # Skip empty lines
        destination="$backup_root/$(basename "$source")_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
        if tar -czf "$destination" "$source" 2>> $log_file; then
            log "Backup created: $destination"
        else
            message="An error occurred while creating backup: $destination"
            log "$message"
            send_email "Backup Error" "$message"
        fi
    fi
done < "$source_list"

message="Backup process completed. Details in $log_file"
log "$message"
send_email "Backup Process Completed" "$message"

echo "Backup process completed. Details in $log_file"
