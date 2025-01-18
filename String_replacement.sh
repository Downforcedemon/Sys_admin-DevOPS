#!/bin/bash

# Directory to search
SEARCH_DIR="."

# String to find and replace
OLD_STRING="2202I15"
NEW_STRING="2202015"

# Find and process files containing the string
grep -rl "$OLD_STRING" "$SEARCH_DIR" | while read -r file; do
    # Replace the string in each file
    sed -i "s/$OLD_STRING/$NEW_STRING/g" "$file"
    echo "Updated: $file"
done

echo "String replacement completed."
