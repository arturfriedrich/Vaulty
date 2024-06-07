#!/bin/bash

source create.sh
source retrieve.sh
source delete.sh

echo "Welcome to Vaulty! What would you like to do?"

while true; do
    echo "(a)dd profile | (f)ind profile data | (r)etrieve all profile data | (d)elete profile data | (q)uit"
    read choice

    case $choice in
        "a") create ;;
        "f") retrieve ;;
        "r") retrieve_all ;;
        "d") delete ;;
        "q") echo "Goodbye!" ; exit 0 ;;
        *) echo "Invalid choice." ;;
    esac
done
