#!/usr/bin/env bash

# This script is used to show the number line of a file
# Usage: ./file_info.sh <file>
# Output: <filename> has <line_number> lines and size of <size>

# Check if the number of arguments is less than 1
if [ $# -lt 1 ]; then
    echo "Usage: ./show_line_number.sh <file>"
    exit 1
fi


# Check if the file exists
if [ ! -f $1 ]; then
    echo "File not found"
    exit 1
fi

# Count the number of lines in the file
line_number=$(wc -l < $1)

# Count the size of the file
size=$(du -h $1 | cut -f1)

# Display the filename, number of lines and size of the file
echo "$1 has $line_number lines and size of $size"
