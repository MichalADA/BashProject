#!/bin/bash

while true; do
    echo "============================"
    echo "      MENU UŻYTKOWNIKA       "
    echo "============================"
    select option in "Wyświetl użytkowników" "Dodaj użytkownika" "Usuń użytkownika" "Zarządzaj grupami" "Wyjdź"; do
        case $REPLY in
            1)
                echo "Lista użytkowników:"
                cut -d: -f1 /etc/passwd | nl
                echo "--------------------------"
                break
                ;;
            2)
                while true; do
                    echo "Wybrałeś: Dodaj użytkownika"
                    read -p "Podaj nazwę użytkownika: " username

                    if id "$username" &>/dev/null; then
                        echo "Użytkownik już istnieje."
                        read -p "Czy chcesz spróbować ponownie? (tak/nie): " retry
                        case $retry in
                            tak|yes)
                                continue # Pozwala na ponowne wprowadzenie użytkownika
                                ;;
                            nie|no)
                                break # Wychodzi z pętli i wraca do głównego menu
                                ;;
                            *)
                                echo "Niewłaściwa odpowiedź. Wybierz 'tak' lub 'nie'."
                                ;;
                        esac
                    else
                        useradd -m -s /bin/bash "$username"
                        echo "Dodano użytkownika: $username"

                        while true; do
                            read -p "Czy chcesz, aby użytkownik miał uprawnienia sudo? (tak/nie): " answer
                            case $answer in
                                tak|yes)
                                    usermod -aG wheel "$username"
                                    echo "Dodano użytkownika do grupy sudo."
                                    break
                                    ;;
                                nie|no)
                                    echo "Pomyslnie dodano użytkownika bez uprawnień sudo."
                                    break
                                    ;;
                                *)
                                    echo "Proszę odpowiedzieć tak lub nie."
                                    ;;
                            esac
                        done
                        break
                    fi
                done
                break
                ;;
            3)
                echo "Lista użytkowników do usunięcia:"
                users_list=($(cut -d: -f1 /etc/passwd))
                for i in "${!users_list[@]}"; do
                    echo "$((i+1))) ${users_list[$i]}"
                done

                read -p "Podaj numer lub nazwę użytkownika do usunięcia: " selection

                if [[ "$selection" =~ ^[0-9]+$ ]]; then
                    username=${users_list[$((selection-1))]}
                else
                    username="$selection"
                fi

                if id "$username" &>/dev/null; then
                    read -p "Czy na pewno chcesz usunąć użytkownika $username? (tak/nie): " answer2
                    case $answer2 in
                        tak|yes)
                            userdel -r "$username"
                            echo "Użytkownik $username został usunięty."
                            ;;
                        nie|no)
                            echo "Anulowano usunięcie użytkownika."
                            ;;
                        *)
                            echo "Niewłaściwa odpowiedź. Spróbuj ponownie."
                            ;;
                    esac
                else
                    echo "Użytkownik $username nie istnieje."
                fi
                break
                ;;
            4)
                echo "Tutaj będzie kod do zarządzania grupami"
                break
                ;;
            5)
                echo "Wychodzenie z programu."
                exit 0
                ;;
            *)
                echo "Niewłaściwy wybór, spróbuj ponownie."
                ;;
        esac
    done
done
