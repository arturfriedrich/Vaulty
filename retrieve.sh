#!/bin/bash

retrieve() {
    echo "Enter the website name to retrieve the profile: "
    read website

    # Read the file and search for the corresponding website
    profile=$(grep "^$website," passwords.txt)
    
    if [ -z "$profile" ]; then
        echo "No profile found for the given website."
    else
        # Split the profile line into fields
        IFS=',' read -r found_website username encrypted_password <<< "$profile"
        
        # Decrypt the password
        password=$(echo "$encrypted_password" | openssl enc -d -des3 -base64 -pass pass:mypasswd -pbkdf2)
        
        echo "Website: $found_website"
        echo "Username: $username"
        echo "Password: $password"
    fi
}

retrieve_all() {
    # Read the file line by line
    while IFS=',' read -r website username encrypted_password; do
        # Decrypt the password
        password=$(echo "$encrypted_password" | openssl enc -d -des3 -base64 -pass pass:mypasswd -pbkdf2)
        
        echo "Website: $website"
        echo "Username: $username"
        echo "Password: $password"
        echo
    done < passwords.txt
}
