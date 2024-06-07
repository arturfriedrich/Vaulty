#!/bin/bash

source create.sh
source retrieve.sh

echo "Welcome to Vaulty! What would you like to do?"
echo "(a)dd profile | (f)ind profile data | (r)etrieve all profile data | (d)elete profile data | (q)uit"
read choice

case $choice in
    "a") create ;;
    "f") retrieve ;;
    *) echo "Invalid choice." ;;
esac
