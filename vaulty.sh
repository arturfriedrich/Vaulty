#!/bin/bash

# Source the necessary files
source colors.sh
source create.sh
source retrieve.sh
source update.sh
source delete.sh

# Function to display ASCII art in the middle of the screen
display_ascii_art() {
    lockImg='
                                   
                                                          ^jEQBQDj^             
                                                       r#@@@@@@@@@#r           
                                                       ?@@@#x_`_v#@@@x          
                                                       g@@@!     !@@@Q          
                                                       Q@@@_     _@@@B          
                                                    rgg@@@@QgggggQ@@@@ggr       
                                                    Y@@@@@@@@@@@@@@@@@@@Y       
                                                    Y@@@@@@@Qx^xQ@@@@@@@Y       
                                                    Y@@@@@@@^   ~@@@@@@@Y       
                                                    Y@@@@@@@@r r#@@@@@@@Y       
                                                    Y@@@@@@@@c,c@@@@@@@@Y       
                                                    Y@@@@@@@@@@@@@@@@@@@Y       
                                                    v###################v       
                                                                
    '
    printf "%s\n" "$lockImg"
}

# Clear the screen
clear

# Display the ASCII art in the middle of the screen
display_ascii_art

printf "Welcome to Vaulty!\n"

hash_master_password() {
    local password="$1"
    # Hash the password using bcrypt
    local hashed_password
    hashed_password=$(htpasswd -bnBC 10 "" "$password" | tr -d ':\n' | sed 's/^://')
    printf "%s\n" "$hashed_password"
}

verify_password() {
    local password="$1"
    local hashed_password="$2"
    # Write the hashed password to a temporary file
    local temp_file
    temp_file=$(mktemp)
    printf "user:%s\n" "$hashed_password" > "$temp_file"
    # Verify the password
    if printf "%s\n" "$password" | htpasswd -v -i "$temp_file" user 2>/dev/null; then
        rm "$temp_file"
        return 1
    else
        rm "$temp_file"
        return 0
    fi
}

# Function to create a master password and store it in passwords.txt
create_master_password() {
    printf "%b\n" "${BLUE}Creating a master password.${NC}"
    printf "%b\n" "${BLUE}Please enter a master password:${NC}"
    read -s master_password

    # Encrypt the master password
    encrypted_master_password=$(hash_master_password "$master_password")

    # Store the encrypted master password in passwords.txt
    printf "%b\n" "$encrypted_master_password" > passwords.txt
    printf "%b\n" "${GREEN}Master password created and stored.${NC}"
}

# Check if passwords.txt exists
if [ ! -f "passwords.txt" ]; then
    printf "%b\n" "${YELLOW}No passwords file found.${NC}"
    create_master_password
else
    # Read the encrypted master password from passwords.txt
    encrypted_master_password=$(head -n 1 passwords.txt)
    
    printf "%b\n" "${BLUE}Please enter the master password to proceed:${NC}"
    read -s entered_password

    # Verify the password
    verify_password "$entered_password" "$encrypted_master_password"
    if [[ $? -eq 1 ]]; then
        printf "%b\n" "${GREEN}Master password accepted.${NC}"
    else
        printf "%b\n" "${RED}Incorrect master password. Exiting.${NC}"
        exit 1
    fi
fi

# Main menu loop with timeout
while true; do
    printf "%b\n" "${BLUE}What would you like to do?${NC}"
    printf "%b\n" "${YELLOW}(a)${NC}dd profile | ${YELLOW}(f)${NC}ind profile data | ${YELLOW}(r)${NC}etrieve all profile data | ${YELLOW}(u)${NC}pdate profile data | ${YELLOW}(d)${NC}elete profile data | ${YELLOW}(q)${NC}uit"

    # Read user input with timeout of 2 minutes (120 seconds)
    read -t 120 choice

    # Check if read timed out
    if [ $? -ne 0 ]; then
        clear
        printf "%b\n" "${RED}Timeout. Exiting.${NC}"
        exit 0
    fi

    case $choice in
        "a") create ;;
        "f") retrieve ;;
        "r") retrieve_all ;;
        "u") update ;;
        "d") delete ;;
        "q") printf "%b\n" "${GREEN}Goodbye!${NC}" ; clear ; exit 0 ;;
        *) printf "%b\n" "${RED}Invalid choice.${NC}" ;;
    esac
done