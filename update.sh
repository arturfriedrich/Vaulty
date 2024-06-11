#!/bin/bash

source password_check.sh

update() {
    printf "%b" "${BLUE}Enter the website name to update the profile: ${NC}"
    read website

    # Check if the profile exists
    if ! grep -q "^$website," passwords.txt; then
        printf "%b\n" "${RED}No profile found for the given website.${NC}"
        return
    fi

    printf "%b" "${BLUE}Enter new username (leave blank to keep existing): ${NC}"
    read new_username

    # Prompt for password update
    printf "%b" "${BLUE}Enter new password (leave blank to keep existing) - (c)reate or (g)enerate password: ${NC}"
    read choice

    # Validate user's choice
    while [ "$choice" != "c" ] && [ "$choice" != "g" ] && [ -n "$choice" ]; do
        printf "%b\n" "${RED}Invalid choice. Please enter 'c', 'g', or leave it blank to move forward.${NC}"
        read choice
    done

    if [ "$choice" == "c" ]; then
        while true; do
            printf "%b" "${BLUE}Password: ${NC}"
            read password
            printf "\n"
            if [ -n "$password" ]; then
                check_password "$password" && break
            else
                # Move forward if password is empty
                break
            fi
        done
    elif [ "$choice" == "g" ]; then
        password=$(openssl rand -base64 16)
    fi

    # Read the file and search for the corresponding website
    while IFS=',' read -r found_website username salt encrypted_password; do
        if [ "$found_website" = "$website" ]; then
            # Update username if provided
            if [ -n "$new_username" ]; then
                sed -i '' "s|^$website,[^,]*|$website,$new_username|" passwords.txt
            fi
            
            # Update password if provided
            if [ -n "$password" ]; then
                # Generate a new salt
                new_salt=$(openssl rand -base64 16)
                # Encrypt the password with the new salt
                new_encrypted_password=$(echo "$password" | openssl enc -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$new_salt")
                
                # Update the line in passwords.txt
                if [ -n "$new_username" ]; then
                    # If new username is provided, update username and password
                    sed -i '' "s|^$website,[^,]*,.*|$website,$new_username,$new_salt,$new_encrypted_password|" passwords.txt
                else
                    # If no new username provided, retain the existing username
                    sed -i '' "s|^$website,[^,]*,.*|$website,$username,$new_salt,$new_encrypted_password|" passwords.txt
                fi
            fi
        fi
    done < passwords.txt
    
    printf "%b" "${GREEN}Profile successfully updated! ${NC}"
    printf "\n"
}