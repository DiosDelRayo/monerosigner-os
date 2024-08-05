#!/bin/bash

# Check if SECRET_SIGNING_KEY environment variable is set
if [ -z "$SECRET_SIGNING_KEY" ]; then
    echo 'Remember to plug in the medium, mount before copy and paste the path!'
    read -p "Enter the path to the secret signing key: " SECRET_SIGNING_KEY
fi

# Check if the file exists
if [ ! -f "$SECRET_SIGNING_KEY" ]; then
    echo "Error: File $SECRET_SIGNING_KEY not found"
    exit 1
fi

# Perform the signing operation
signify-openbsd -S -s "$SECRET_SIGNING_KEY" -m SHA256
