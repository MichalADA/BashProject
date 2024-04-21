#!/bin/bash

# Plik zawierający listę serwerów
server_file="servers.txt"

# Plik lub katalog do przesłania
file_to_send="path/to/your/file_or_directory"

# Docelowa ścieżka na serwerze, gdzie plik/katalog zostanie zapisany
destination_path="/path/on/server/"

# Funkcja przesyłająca plik lub katalog
send_file() {
    local server=$1
    echo "Przesyłam plik/katalog do $server..."
    scp -r "$file_to_send" admin@"$server":"$destination_path"
}

# Główna pętla przez wszystkie serwery
while IFS= read -r server
do
    echo "Wykonuję operację na $server..."
    send_file "$server"
done < "$server_file"

echo "Skrypt zakończył działanie."
