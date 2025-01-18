#!/bin/bash

# File containing the list of processed files
PROCESSED_FILES="processed_files.lst"

# List of filenames to check against
FILE_LIST="file_list.txt"

# Write the provided file names to file_list.txt
cat > "$FILE_LIST" <<EOL
<add integers to remove here>
EOL

# Check if the processed_files.lst exists
if [[ ! -f "$PROCESSED_FILES" ]]; then
    echo "Error: File '$PROCESSED_FILES' not found!"
    exit 1
fi

# Check if the file_list.txt is not empty
if [[ ! -s "$FILE_LIST" ]]; then
    echo "Error: '$FILE_LIST' is empty! Add file names to remove."
    exit 1
fi

# Filter out the entries from processed_files.lst that are in file_list.txt
grep -vFf "$FILE_LIST" "$PROCESSED_FILES" > temp.lst

# Ensure `temp.lst` was successfully created
if [[ -f temp.lst ]]; then
    # Overwrite the original file with filtered content
    mv temp.lst "$PROCESSED_FILES"
    echo "Processed files have been cleaned from $PROCESSED_FILES."
else
    echo "Error: Something went wrong during filtering."
    exit 1
fi
