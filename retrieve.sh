#!/bin/bash

source colors.sh

# Detect the clipboard command based on the OS
if command -v xclip &> /dev/null; then
    CLIP_CMD="xclip -selection clipboard"
elif command -v pbcopy &> /dev/null; then
    CLIP_CMD="pbcopy"
else
    echo "${RED}Clipboard command not found. Please install xclip or pbcopy.${NC}"
    exit 1
fi

retrieve() {
    while true; do
        echo "${BLUE}Enter the website name to retrieve the profile: ${NC}"
        read website

        # Read the file and search for the corresponding website
        profile=$(grep "^$website," passwords.txt)
        
        if [ -z "$profile" ]; then
            echo "${RED}No profile found for the given website. Please try again.${NC}"
        else
            # Split the profile line into fields
            IFS=',' read -r found_website username encrypted_password <<< "$profile"
            
            # Decrypt the password
            password=$(echo "$encrypted_password" | openssl enc -d -des3 -base64 -pass pass:mypasswd -pbkdf2)
            
            echo "${GREEN}Website: $found_website${NC}"
            echo "${GREEN}Username: $username${NC}"
            echo "${GREEN}Password: $password${NC}"
            
            while true; do
                echo "${BLUE}Would you like to copy the (u)sername, (p)assword, or (q)uit? ${NC}"
                read copy_choice
                case $copy_choice in
                    "u")
                        printf "%s" "$username" | $CLIP_CMD
                        echo "${GREEN}Username copied to clipboard.${NC}"
                        ;;
                    "p")
                        printf "%s" "$password" | $CLIP_CMD
                        echo "${GREEN}Password copied to clipboard.${NC}"
                        ;;
                    "q")
                        break 2
                        ;;
                    *)
                        echo "${RED}Invalid choice. Please enter 'u', 'p', or 'q'.${NC}"
                        ;;
                esac
            done
            break
        fi
    done
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
