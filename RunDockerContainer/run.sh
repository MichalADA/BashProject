#!/bin/bash

# Ścieżki
SOURCE_DIR="/home/Linux/data"
BACKUP_DIR="/home/Linux/backup"
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

# Sprawdzanie, czy katalog backupu istnieje
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Tworzę katalog backupu: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# Tworzenie backupu
echo "Tworzę kopię zapasową katalogu $SOURCE_DIR..."
if tar -czf "$BACKUP_FILE" "$SOURCE_DIR"; then
    echo "Backup zakończony sukcesem. Plik: $BACKUP_FILE"
else
    echo "Wystąpił błąd podczas tworzenia backupu!"
    exit 1
fi

# Uruchamianie kontenera Dockerowego
CONTAINER_NAME="nginx_backup"
IMAGE_NAME="nginx:1.21-alpine"
echo "Sprawdzam, czy obraz $IMAGE_NAME jest dostępny lokalnie..."
docker image inspect $IMAGE_NAME > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Obraz $IMAGE_NAME nie istnieje lokalnie. Pobieram z Docker Hub..."
    docker pull $IMAGE_NAME
    if [ $? -ne 0 ]; then
        echo "Wystąpił błąd podczas pobierania obrazu $IMAGE_NAME!"
        exit 1
    fi
else
    echo "Obraz $IMAGE_NAME jest już dostępny lokalnie."
fi

echo "Uruchamiam kontener Dockerowy: $CONTAINER_NAME"
if docker run -d --name "$CONTAINER_NAME" -p 8080:80 -v "$BACKUP_DIR:/usr/share/nginx/html:ro" "$IMAGE_NAME"; then
    echo "Kontener uruchomiony. Aplikacja dostępna na porcie 8080."
else
    echo "Wystąpił błąd podczas uruchamiania kontenera!"
    exit 1
fi
