#!/bin/bash

# File containing the list of servers
server_file="servers.txt"

email="myadress@email.com"

# Package files for Debian versions
declare -A packages=(
    [10]="deb http://deb.debian.org/debian/ buster main non-free contrib
deb http://deb.debian.org/debian/ buster-updates main non-free contrib
deb http://security.debian.org/ buster/updates main non-free contrib"
    [11]="deb http://deb.debian.org/debian bullseye main contrib non-free
deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb http://security.debian.org/debian-security bullseye-security main contrib non-free"
    [12]="deb http://deb.debian.org/debian bookworm main contrib non-free-firmware non-free
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware non-free
deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware non-free"
)

# Function to update system repositories
update_repos() {
    local server=$1
    local os_version=$(ssh admin@"$server" "cat /etc/os-release | grep VERSION_ID | cut -d '\"' -f 2" | tr -d '.')
    
    if [[ -n ${packages[$os_version]} ]]; then
        echo "Updating repositories for Debian $os_version on $server..."
        ssh admin@"$server" "echo '${packages[$os_version]}' | sudo tee /etc/apt/sources.list > /dev/null && sudo apt-get update && sudo apt-get upgrade -y"
        echo "Fetching journalctl logs from $server..."
        ssh admin@"$server" "journalctl -xe" > "/tmp/journal_${server}.log"
        echo "Sending journalctl logs to $email"
        mail -s "Journalctl logs from $server" "$email_address" < "/tmp/journal_${server}.log"
    else
        echo "No repository info for Debian $os_version on $server or Debian 12 (no action needed)."
    fi
}

# Main loop through all servers
while IFS= read -r server
do
    echo "Executing on $server..."
    update_repos "$server"
done < "$server_file"

echo "Script has completed."
