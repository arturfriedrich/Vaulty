#!/bin/bash

source colors.sh

retrieve() {
    echo "${BLUE}Enter the website name to retrieve the profile: ${NC}"
    read website

    # Read the file and search for the corresponding website
    profile=$(grep "^$website," passwords.txt)
    
    if [ -z "$profile" ]; then
        echo "${RED}No profile found for the given website.${NC}"
    else
        # Split the profile line into fields
        IFS=',' read -r found_website username encrypted_password <<< "$profile"
        
        # Decrypt the password
        password=$(echo "$encrypted_password" | openssl enc -d -des3 -base64 -pass pass:mypasswd -pbkdf2)
        
        echo "${GREEN}Website: $found_website${NC}"
        echo "${GREEN}Username: $username${NC}"
        echo "${GREEN}Password: $password${NC}"
    fi
}

retrieve_all() {
    if [ ! -s passwords.txt ]; then
        echo "${RED}No profiles found.${NC}"
        return
    fi

    # Read the file line by line
    while IFS=',' read -r website username encrypted_password; do
        # Decrypt the password
        password=$(echo "$encrypted_password" | openssl enc -d -des3 -base64 -pass pass:mypasswd -pbkdf2)
        
        echo "${GREEN}Website: $website${NC}"
        echo "${GREEN}Username: $username${NC}"
        echo "${GREEN}Password: $password${NC}"
        echo "${YELLOW}-------------------------${NC}"
    done < passwords.txt
}
