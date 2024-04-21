#!/bin/bash

read -p "Podaj początkowy adres IP: " start_ip
read -p "Podaj konczowy adres IP: " end_ip 


ip_to_int() {
    local IFS=.
    read ip1 ip2 ip3 ip4 <<< "$!1"
    echo "$((ip1 * 256 ** 3 + ip2 * 256 ** 2 + ip3 * 256 + ip4))"
}


int_to_ip() {
    local ip="$1"
    local ip4=$((ip % 256)); ip=$((ip / 256))
    local ip3=$((ip % 256)); ip=$((ip / 256))
    local ip2=$((ip % 256)); ip=$((ip / 256))
    local ip1=$ip
    echo "$ip1.$ip2.$ip3.$ip4"
}


start=$(ip_to_int "$start_ip")
end=$(ip_to_int "$end_ip")


for ip in $(seq $start $end); do 
    current_ip=$(int_to_ip "$ip")
    # Użyj polecenia ping z timeoutem 1 sekundę, wysyłając tylko jeden pakiet
    if ping -c 1 -W 1 "$current_ip" &> /dev/null; then
        echo "$current_ip jest aktywny"
    else
        echo "$current_ip jest nieaktywny"
    fi
done

echo "Skanowanie zakończone."