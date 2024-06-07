#!/bin/bash

source colors.sh

# Function to check if the password meets certain criteria
check_password() {
    local password="$1"
    local password_length=${#password}
    local has_lowercase=$(echo "$password" | grep -c '[a-z]')
    local has_uppercase=$(echo "$password" | grep -c '[A-Z]')
    local has_digit=$(echo "$password" | grep -c '[0-9]')

    if [ $password_length -lt 8 ]; then
        echo "${RED}Password must be at least 8 characters long.${NC}"
        return 1
    fi

    if [ $has_lowercase -eq 0 ] || [ $has_uppercase -eq 0 ] || [ $has_digit -eq 0 ]; then
        echo "${RED}Password must contain at least one lowercase letter, one uppercase letter, and one digit.${NC}"
        return 1
    fi

    # Password meets all criteria
    return 0
}
