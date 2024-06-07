#!/bin/bash

delete() {
    echo "Enter the website name to delete the profile: "
    read website

    # Check if the profile exists
    profile=$(grep "^$website," passwords.txt)
    
    if [ -z "$profile" ]; then
        echo "No profile found for the given website."
    else
        # Delete the profile line from the file
        grep -v "^$website," passwords.txt > temp.txt && mv temp.txt passwords.txt
        echo "Profile for $website deleted."
    fi
}
