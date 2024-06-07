#!/bin/bash

source colors.sh

create() {
    echo "${BLUE}Website name: ${NC}"
    read website
    echo "${BLUE}Username: ${NC}"
    read username
    echo "${YELLOW}(c)reate or (g)enerate password? ${NC}"
    read choice
    
    if [ "$choice" == "c" ]; then
        echo "${BLUE}Password: ${NC}"
        read password
    else
        password=$(openssl rand -base64 16)
    fi
    
    # Encrypt the password
    encrypted_password=$(echo $password | openssl enc -e -des3 -base64 -pass pass:mypasswd -pbkdf2)
    
    # Save the record to the file
    echo "$website,$username,$encrypted_password" >> passwords.txt
    
    echo "${GREEN}Record saved${NC}"
}
