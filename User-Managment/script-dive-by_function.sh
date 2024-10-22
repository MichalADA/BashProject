#!/bin/bash

# Function to display the list of users
display_users() {
    echo "Lista użytkowników:"
    cut -d: -f1 /etc/passwd | nl
    echo "--------------------------"
}

# Function to add a user
add_user() {
    while true; do
        echo "Wybrałeś: Dodaj użytkownika"
        read -p "Podaj nazwę użytkownika: " username

        if id "$username" &>/dev/null; then
            echo "Użytkownik już istnieje."
            read -p "Czy chcesz spróbować ponownie? (tak/nie): " retry
            case $retry in
                tak|yes) continue ;;
                nie|no) break ;;
                *) echo "Niewłaściwa odpowiedź. Wybierz 'tak' lub 'nie'." ;;
            esac
        else
            sudo useradd -m -s /bin/bash "$username"
            echo "Dodano użytkownika: $username"

            while true; do
                read -p "Czy chcesz, aby użytkownik miał uprawnienia sudo? (tak/nie): " answer
                case $answer in
                    tak|yes)
                        sudo usermod -aG sudo "$username"
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
}

# Function to delete a user
delete_user() {
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
                sudo userdel -r "$username"
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
}

# Function to manage groups
manage_groups() {
    while true; do
        echo "Menu zarządzania grupami:"
        echo "1) Tworzenie grupy"
        echo "2) Wyświetlenie listy grup"
        echo "3) Usuwanie grupy"
        echo "4) Dodanie użytkownika do grupy"
        echo "5) Powrót do głównego menu"
        read -p "Wybierz opcję: " opcja

        case $opcja in
            1)
                read -p "Podaj nazwę grupy do utworzenia: " group_name
                sudo groupadd "$group_name"
                if [ $? -eq 0 ]; then
                    echo "Grupa '$group_name' została pomyślnie utworzona."
                else
                    echo "Wystąpił problem podczas tworzenia grupy '$group_name'."
                fi
                ;;
            2)
                echo "Lista grup:"
                cut -d: -f1 /etc/group
                ;;
            3)
                read -p "Podaj nazwę grupy do usunięcia: " group_name
                sudo groupdel "$group_name"
                if [ $? -eq 0 ]; then
                    echo "Grupa '$group_name' została pomyślnie usunięta."
                else
                    echo "Wystąpił problem podczas usuwania grupy '$group_name'."
                fi
                ;;
            4)
                # List all available users
                echo "Lista dostępnych użytkowników:"
                cut -d: -f1 /etc/passwd | nl
                echo "------------------------------"
                
                read -p "Podaj nazwę użytkownika do dodania: " user_name
                
                # List available groups without line numbers
                echo "Lista dostępnych grup:"
                cut -d: -f1 /etc/group
                echo "------------------------------"
                
                read -p "Podaj nazwę grupy, do której dodać użytkownika: " group_name
                
                # Add the user to the selected group
                sudo usermod -aG "$group_name" "$user_name"
                
                if [ $? -eq 0 ]; then
                    echo "Użytkownik '$user_name' został pomyślnie dodany do grupy '$group_name'."
                else
                    echo "Wystąpił problem podczas dodawania użytkownika '$user_name' do grupy '$group_name'."
                fi
                
                ;;
            5) break ;;
            *) echo "Niewłaściwy wybór, spróbuj ponownie." ;;
        esac
    done
}

# Main menu
while true; do
    echo "============================"
    echo "      MENU UŻYTKOWNIKA       "
    echo "============================"
    select option in "Wyświetl użytkowników" "Dodaj użytkownika" "Usuń użytkownika" "Zarządzaj grupami" "Wyjdź"; do
        case $REPLY in
            1) display_users; break ;;
            2) add_user; break ;;
            3) delete_user; break ;;
            4) manage_groups; break ;;
            5) echo "Wychodzenie z programu."; exit 0 ;;
            *) echo "Niewłaściwy wybór, spróbuj ponownie." ;;
        esac
    done
done
