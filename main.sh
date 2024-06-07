#!/bin/bash

source colors.sh
source create.sh
source retrieve.sh
source delete.sh

while true; do
    echo "${BLUE}Welcome to Vaulty! What would you like to do?${NC}"
    echo "${YELLOW}(a)dd profile | (f)ind profile data | (r)etrieve all profile data | (d)elete profile data | (q)uit${NC}"
    read choice

    case $choice in
        "a") create ;;
        "f") retrieve ;;
        "r") retrieve_all ;;
        "d") delete ;;
        "q") echo "${GREEN}Goodbye!${NC}" ; exit 0 ;;
        *) echo "${RED}Invalid choice.${NC}" ;;
    esac
done
