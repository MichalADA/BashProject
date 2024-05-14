#!/bin/bash

# Zapytaj użytkownika o interfejs sieciowy do monitorowania
read -p "Podaj nazwę interfejsu sieciowego (np. eth0): " interface

# Zapytaj użytkownika o filtr IP (opcjonalnie)
read -p "Podaj filtr IP (np. 'src 192.168.1.1' lub zostaw puste, jeśli nie potrzebujesz): " ip_filter

# Zapytaj użytkownika o filtr portu (opcjonalnie)
read -p "Podaj filtr portu (np. 'port 80' lub zostaw puste, jeśli nie potrzebujesz): " port_filter

# Skonstruuj finalny filtr dla tcpdump
filter=""
if [[ ! -z "$ip_filter" ]]; then
    filter="$ip_filter"
fi
if [[ ! -z "$port_filter" ]]; then
    if [[ ! -z "$filter" ]]; then
        filter="$filter and $port_filter"
    else
        filter="$port_filter"
    fi
fi

# Nazwa pliku logu
logfile="network_traffic_$(date +%Y%m%d_%H%M%S).log"

# Uruchom tcpdump
echo "Uruchamiam monitorowanie ruchu sieciowego na $interface. Wyniki będą zapisywane w $logfile."
sudo tcpdump -i "$interface" -n "$filter" -w "$logfile" &
echo "tcpdump uruchomiony w tle. Aby zakończyć monitorowanie, użyj komendy 'sudo kill $!'."

# Instrukcja dla użytkownika, jak zakończyć monitorowanie
echo "Aby zatrzymać tcpdump, użyj polecenia 'kill $!' lub 'sudo killall tcpdump'."
