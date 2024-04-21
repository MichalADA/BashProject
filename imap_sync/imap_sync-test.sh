
#!/bin/bash

# Definicja serwerów źródłowych i docelowych
SOURCE_SERVER="Source Server"
DESTINATION_SERVER="Adres IP"

# Tablica użytkowników i haseł
declare -a USERS=("user1@example.com:password1234"
                  "user2@example.com:password2345"
                  "user3@example.com:password3456"
                  "user4@example.com:password4567"
                  "user5@example.com:password5678"
                  "user6@example.com:password6789"
                  "user7@example.com:password7890"
                  "user8@example.com:password8901"
                  "user9@example.com:password9012")

# Pętla przez każdego użytkownika i hasło
for userpass in "${USERS[@]}"
do
    IFS=':' read -r user password <<< "$userpass"
    destination_user="${user//@/.}" # Podmienia @ na . dla serwera docelowego
    echo "Synchronizacja konta $user na $destination_user..."
    imapsync --host1 $SOURCE_SERVER --user1 $user --password1 $password --host2 $DESTINATION_SERVER --user2 $destination_user --password2 $password > "/tmp/raport_${destination_user}.txt"
done

echo "Synchronizacja zakończona."
