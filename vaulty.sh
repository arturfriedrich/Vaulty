#!/bin/bash

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
    
    printf "$lockImg"
}

# Clear the screen
clear

# Display the ASCII art in the middle of the screen
display_ascii_art

echo "Welcome to Vaulty!"

# Function to create a master password and store it in passwords.txt
create_master_password() {
    echo "${BLUE}Creating a master password.${NC}"
    echo "${BLUE}Please enter a master password:${NC}"
    read -s master_password

    # Encrypt the master password
    encrypted_master_password=$(echo "$master_password" | openssl enc -e -des3 -base64 -pass pass:mypasswd -pbkdf2)

    # Store the encrypted master password in passwords.txt
    echo "$encrypted_master_password" > passwords.txt
    echo "${GREEN}Master password created and stored.${NC}"
}

# Check if passwords.txt exists
if [ ! -f "passwords.txt" ]; then
    echo "${YELLOW}No passwords file found.${NC}"
    create_master_password
else
    # Read the encrypted master password from passwords.txt
    encrypted_master_password=$(head -n 1 passwords.txt)
    
    echo "${BLUE}Please enter the master password to proceed:${NC}"
    read -s entered_password

    # Decrypt the master password from passwords.txt
    master_password=$(echo "$encrypted_master_password" | openssl enc -d -des3 -base64 -pass pass:mypasswd -pbkdf2)

    # Check if the entered password matches the master password
    if [ "$entered_password" != "$master_password" ]; then
        echo "${RED}Incorrect master password. Exiting.${NC}"
        exit 1
    fi

    echo "${GREEN}Master password accepted.${NC}"
fi

# Main menu loop with timeout
while true; do
    echo "${BLUE}What would you like to do?${NC}"
    echo "${YELLOW}(a)${NC}dd profile | ${YELLOW}(f)${NC}ind profile data | ${YELLOW}(r)${NC}etrieve all profile data | ${YELLOW}(u)${NC}pdate profile data | ${YELLOW}(d)${NC}elete profile data | ${YELLOW}(q)${NC}uit"

    # Read user input with timeout of 2 minutes (120 seconds)
    read -t 120 choice

    # Check if read timed out
    if [ $? -ne 0 ]; then
        clear
        echo "${RED}Timeout. Exiting.${NC}"
        exit 0
    fi

    case $choice in
        "a") create ;;
        "f") retrieve ;;
        "r") retrieve_all ;;
        "u") update ;;
        "d") delete ;;
        "q") echo "${GREEN}Goodbye!${NC}" ; clear ; exit 0 ;;
        *) echo "${RED}Invalid choice.${NC}" ;;
    esac
done