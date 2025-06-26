#!/bin/bash

# Colors for output
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root!${RESET}"
    exit 1
fi

# Display Menu
show_menu() {
    echo -e "${YELLOW}========= Linux User Management =========${RESET}"
    echo "1) Check if user exists"
    echo "2) Add user"
    echo "3) Delete user"
    echo "4) Change user password"
    echo "5) Lock user account"
    echo "6) Unlock user account"
    echo "7) Show system info"
    echo "8) Show user info"
    echo "9) Exit"
    echo -n "Enter your choice [1-9]: "
}

# Check if user exists
check_user() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo -e "${GREEN}User '$username' exists.${RESET}"
    else
        echo -e "${RED}User '$username' does not exist.${RESET}"
    fi
}

# Add a new user
add_user() {
    read -p "Enter new username: " username
    if id "$username" &>/dev/null; then
        echo -e "${RED}User already exists.${RESET}"
    else
        useradd "$username" && echo -e "${GREEN}User '$username' added.${RESET}"
        passwd "$username"
    fi
}

# Delete user
delete_user() {
    read -p "Enter username to delete: " username
    if id "$username" &>/dev/null; then
        userdel -r "$username" && echo -e "${GREEN}User '$username' deleted.${RESET}"
    else
        echo -e "${RED}User does not exist.${RESET}"
    fi
}

# Change password
change_password() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        passwd "$username"
    else
        echo -e "${RED}User does not exist.${RESET}"
    fi
}

# Lock account
lock_user() {
    read -p "Enter username to lock: " username
    if id "$username" &>/dev/null; then
        passwd -l "$username" && echo -e "${YELLOW}User '$username' locked.${RESET}"
    else
        echo -e "${RED}User does not exist.${RESET}"
    fi
}

# Unlock account
unlock_user() {
    read -p "Enter username to unlock: " username
    if id "$username" &>/dev/null; then
        passwd -u "$username" && echo -e "${GREEN}User '$username' unlocked.${RESET}"
    else
        echo -e "${RED}User does not exist.${RESET}"
    fi
}

# Show system info
system_info() {
    echo -e "${YELLOW}System Info:${RESET}"
    uname -a
    echo -e "\nHostname: $(hostname)"
    echo -e "Uptime: $(uptime -p)"
    echo -e "Logged-in users:"
    who
}

# Show user info
user_info() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo -e "${YELLOW}User Info for '$username':${RESET}"
        id "$username"
        echo "Home Directory: $(eval echo ~$username)"
        echo "Shell: $(getent passwd $username | cut -d: -f7)"
        lastlog -u "$username"
    else
        echo -e "${RED}User does not exist.${RESET}"
    fi
}

# Main loop
while true; do
    show_menu
    read choice
    case $choice in
        1) check_user ;;
        2) add_user ;;
        3) delete_user ;;
        4) change_password ;;
        5) lock_user ;;
        6) unlock_user ;;
        7) system_info ;;
        8) user_info ;;
        9) echo -e "${YELLOW}Exiting...${RESET}"; break ;;
        *) echo -e "${RED}Invalid choice!${RESET}" ;;
    esac
    echo -e "\nPress Enter to continue..."
    read
done
