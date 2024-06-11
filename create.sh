#!/bin/bash

create() {
    printf "%b" "${BLUE}Website name: ${NC}"
    read website
    printf "%b" "${BLUE}Username: ${NC}"
    read username
    printf "%b" "${YELLOW}(c)reate or (g)enerate password? ${NC}"
    read choice
    
    if [ "$choice" == "c" ]; then
        while true; do
            printf "%b" "${BLUE}Password: ${NC}"
            read -s password
            printf "\n"
            if check_password "$password"; then
                break
            fi
        done
    else
        password=$(openssl rand -base64 16)
    fi
    
    # Generate a random salt
    salt=$(openssl rand -base64 16)
    
    # Encrypt the password with the salt
    encrypted_password=$(printf "%s" "$password" | openssl enc -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$salt")
    
    # Save the record to the file
    printf "%s,%s,%s,%s\n" "$website" "$username" "$salt" "$encrypted_password" >> passwords.txt
    
    printf "%b\n" "${GREEN}Record saved${NC}"
}

