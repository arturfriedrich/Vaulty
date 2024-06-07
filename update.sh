#!/bin/bash

source colors.sh
source password_check.sh

update() {
    echo "${BLUE}Enter the website name to update the profile: ${NC}"
    read website

    # Check if the profile exists
    if ! grep -q "^$website," passwords.txt; then
        echo "${RED}No profile found for the given website.${NC}"
        return
    fi

    echo "${BLUE}Enter new username (leave blank to keep existing): ${NC}"
    read new_username

    # Prompt for password update
    echo "${BLUE}Enter new password (leave blank to keep existing) - (c)reate or (g)enerate password: ${NC}"
    read choice

    # Validate user's choice
    while [ "$choice" != "c" ] && [ "$choice" != "g" ]; do
        echo "${RED}Invalid choice. Please enter 'c' or 'g'.${NC}"
        read choice
    done

    if [ "$choice" == "c" ]; then
        while true; do
            echo "${BLUE}Password: ${NC}"
            read password
            echo
            check_password "$password" && break
        done
    else
        password=$(openssl rand -base64 16)
    fi

    # Read the file and search for the corresponding website
    while IFS=',' read -r found_website username encrypted_password; do
        if [ "$found_website" = "$website" ]; then
            # Update username if provided
            if [ -n "$new_username" ]; then
                sed -i '' "s/^$website,$username/$website,$new_username/" passwords.txt
            fi
            # Update password if provided
            if [ -n "$password" ]; then
                encrypted_password=$(echo "$password" | openssl enc -e -des3 -base64 -pass pass:mypasswd -pbkdf2)
                sed -i '' "s/^$website,.*$/$website,$new_username,$encrypted_password/" passwords.txt
            fi
            echo "${GREEN}Profile updated.${NC}"
            return
        fi
    done < passwords.txt
}