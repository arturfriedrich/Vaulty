#!/bin/bash

# Detect the clipboard command based on the OS
if command -v xclip &> /dev/null; then
    CLIP_CMD="xclip -selection clipboard"
elif command -v pbcopy &> /dev/null; then
    CLIP_CMD="pbcopy"
else
    printf "%b\n" "${RED}Clipboard command not found. Please install xclip or pbcopy.${NC}"
    exit 1
fi

rehash_passwords() {
    # Generate a new random salt
    new_salt=$(openssl rand -base64 8)

    # Temporary file to store updated passwords
    temp_file=$(mktemp)

    # Read the master password and salt from the first row
    master_password_line=$(head -n 1 passwords.txt)
    master_password=$(echo "$master_password_line" | cut -d',' -f1)
    salt=$(echo "$master_password_line" | cut -d',' -f2)
    salt=$(head -c 16 /dev/urandom | base64)

    # Preserve the master password without rehashing
    printf "%b\n" "$master_password_line" >> "$temp_file"

    # Read the remaining password records and rehash them
    tail -n +2 passwords.txt |
    while IFS=',' read -r website username salt encrypted_password; do
        # Decrypt the password
        password=$(echo "$encrypted_password" | openssl enc -d -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$salt")

        # Re-encrypt the password with the new salt
        new_encrypted_password=$(echo "$password" | openssl enc -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$new_salt")

        # Append the updated record to the temp file
        printf "%s,%s,%s,%s\n" "$website" "$username" "$new_salt" "$new_encrypted_password" >> "$temp_file"
    done

    # Replace the original passwords file with the updated temp file
    mv "$temp_file" passwords.txt
}

retrieve() {
    rehash_passwords
    while true; do
        printf "%b" "${BLUE}Enter the website name to retrieve the profile (or enter 'q' to quit): ${NC}"
        read website

        # Check if the user wants to quit
        if [ "$website" = "q" ]; then
            printf "%b\n" "${GREEN}Exiting.${NC}"
            return
        fi

        # Read the file and search for the corresponding website
        profile=$(grep "^$website," passwords.txt)
        
        if [ -z "$profile" ]; then
            printf "%b\n" "${RED}No profile found for the given website. Please try again.${NC}"
        else
            # Split the profile line into fields
            IFS=',' read -r found_website username salt encrypted_password <<< "$profile"
            
            # Decrypt the password
            password=$(echo "$encrypted_password" | openssl enc -d -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$salt")
            
            printf "%b\n" "${GREEN}Website: $found_website${NC}"
            printf "%b\n" "${GREEN}Username: $username${NC}"
            printf "%b\n" "${GREEN}Password: $password${NC}"
            
            while true; do
                printf "%b" "${BLUE}Would you like to copy the (u)sername, (p)assword, or (q)uit? ${NC}"
                read copy_choice
                case $copy_choice in
                    "u")
                        printf "%s" "$username" | $CLIP_CMD
                        printf "%b\n" "${GREEN}Username copied to clipboard.${NC}"
                        ;;
                    "p")
                        printf "%s" "$password" | $CLIP_CMD
                        printf "%b\n" "${GREEN}Password copied to clipboard.${NC}"
                        ;;
                    "q")
                        printf "%b\n" "${GREEN}Exiting.${NC}"
                        return
                        ;;
                    *)
                        printf "%b\n" "${RED}Invalid choice. Please enter 'u', 'p', or 'q'.${NC}"
                        ;;
                esac
            done
            break
        fi
    done
}

retrieve_all() {
    rehash_passwords
    if [ ! -s passwords.txt ]; then
        printf "%b\n" "${RED}No profiles found.${NC}"
        return
    fi

    # Skip the first line (header)
    tail -n +2 passwords.txt |
    while IFS=',' read -r website username salt encrypted_password; do
        # Decrypt the password
        password=$(echo "$encrypted_password" | openssl enc -d -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$salt")
        
        printf "%b\n" "${GREEN}Website: $website${NC}"
        printf "%b\n" "${GREEN}Username: $username${NC}"
        printf "%b\n" "${GREEN}Password: $password${NC}"
        printf "%b\n" "${YELLOW}-------------------------${NC}"
    done

    # Wait for the user to press 'q' to quit
    while true; do
        printf "%b\n" "${BLUE}Press 'q' to quit.${NC}"
        read -n 1 -s key
        if [ "$key" = "q" ]; then
            printf "%b\n" "${GREEN}Exiting.${NC}"
            return
        fi
    done
}

