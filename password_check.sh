# vaulty_password_check.sh

check_password() {
    local password="$1"
    local length=${#password}
    
    if [ $length -lt 8 ]; then
        printf "%s\n" "${RED}Password must be at least 8 characters long.${NC}"
        return 1
    fi

    if ! [[ "$password" =~ [A-Z] ]]; then
        printf "%b\n" "${RED}Password must contain at least one uppercase letter.${NC}"
        return 1
    fi

    if ! [[ "$password" =~ [a-z] ]]; then
        printf "%b\n" "${RED}Password must contain at least one lowercase letter.${NC}"
        return 1
    fi

    if ! [[ "$password" =~ [0-9] ]]; then
        printf "%b\n" "${RED}Password must contain at least one number.${NC}"
        return 1
    fi

    if ! [[ "$password" =~ [^a-zA-Z0-9] ]]; then
        printf "%b\n" "${RED}Password must contain at least one special character.${NC}"
        return 1
    fi

    return 0
}
