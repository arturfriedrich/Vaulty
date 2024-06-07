#!/bin/bash

create() {
    echo "Website name: "
    read website
    echo "Username: "
    read username
    echo "(c)reate or (g)enerate password? "
    read choice
    
    if [ "$choice" == "c" ]; then
        echo "Password: "
        read password
        # Check if password is at least 8 characters long
        while [ ${#password} -lt 8 ]; do
            echo "Password must be at least 8 characters long"
            echo "Password: "
            read password
        done
        
        # Check if password contains at least one uppercase letter
        while ! [[ "$password" =~ [A-Z] ]]; do
            echo "Password must contain at least one uppercase letter"
            echo "Password: "
            read password
        done
        
        # Check if password contains at least one lowercase letter
        while ! [[ "$password" =~ [a-z] ]]; do
            echo "Password must contain at least one lowercase letter"
            echo "Password: "
            read password
        done
        
        # Check if password contains at least one number
        while ! [[ "$password" =~ [0-9] ]]; do
            echo "Password must contain at least one number"
            echo "Password: "
            read password
        done
        
        # Check if password contains at least one special character
        while ! [[ "$password" =~ [^a-zA-Z0-9] ]]; do
            echo "Password must contain at least one special character"
            echo "Password: "
            read password
        done
    else
        password=$(openssl rand -base64 16)
    fi
    
    # Encrypt the password
    encrypted_password=$(echo $password | openssl enc -e -des3 -base64 -pass pass:mypasswd -pbkdf2)
    
    # Save the record to the file
    echo "$website,$username,$encrypted_password" >> passwords.txt
    
    echo "Record saved"
    
}