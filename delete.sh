#!/bin/bash

source colors.sh

delete() {
    echo "${BLUE}Enter the website name to delete the profile: ${NC}"
    read website

    # Check if the profile exists
    profile=$(grep "^$website," passwords.txt)
    
    if [ -z "$profile" ]; then
        echo "${RED}No profile found for the given website.${NC}"
    else
        # Delete the profile line from the file
        grep -v "^$website," passwords.txt > temp.txt && mv temp.txt passwords.txt
        echo "${GREEN}Profile for $website deleted.${NC}"
    fi
}
