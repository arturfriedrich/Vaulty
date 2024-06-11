#!/bin/bash

delete() {
    printf "%b" "${BLUE}Enter the website name to delete the profile: ${NC}"
    read website

    # Check if the profile exists
    profile=$(grep "^$website," passwords.txt)
    
    if [ -z "$profile" ]; then
        printf "%b\n" "${RED}No profile found for the given website.${NC}"
    else
        # Delete the profile line from the file
        grep -v "^$website," passwords.txt > temp.txt && mv temp.txt passwords.txt
        printf "%b\n" "${GREEN}Profile for $website deleted.${NC}"
    fi
}
