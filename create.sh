create() {
    echo "${BLUE}Website name: ${NC}"
    read website
    echo "${BLUE}Username: ${NC}"
    read username
    echo "${YELLOW}(c)reate or (g)enerate password? ${NC}"
    read choice
    
    if [ "$choice" == "c" ]; then
        while true; do
            echo "${BLUE}Password: ${NC}"
            read password
            echo
            check_password "$password" && break
        done
    else
        password=$(openssl rand -base64 16)
    fi
    
    # Generate a random salt
    salt=$(openssl rand -base64 16)
    
    # Encrypt the password with the salt
    encrypted_password=$(echo "$password" | openssl enc -aes-128-cbc -a -salt -pbkdf2 -pass pass:"$salt")
    
    # Save the record to the file
    echo "$website,$username,$salt,$encrypted_password" >> passwords.txt
    
    echo "${GREEN}Record saved${NC}"
}