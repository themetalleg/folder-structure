#!/bin/bash

# Set the directory name where the script is located
APP_DIR="$(pwd)"

# Output file
OUTPUT_FILE="django_app_structure.txt"

# Clear the output file
> "$OUTPUT_FILE"

# Function to check if the file is a binary
is_binary() {
    local file="$1"
    if [[ $(file --mime "$file" | grep -E 'charset=binary') ]]; then
        return 0
    else
        return 1
    fi
}

# Print the directory structure excluding migrations and __init__.py files
echo "Directory structure (excluding migrations and __init__.py files):" >> "$OUTPUT_FILE"
tree -I "__pycache__|migrations|*.pyc|__init__.py" "$APP_DIR" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find all files excluding the ones we don't want
find "$APP_DIR" -type f \( ! -iname "migrations" ! -iname "__init__.py" \) | while read -r file; do
    # Check if file is binary
    if ! is_binary "$file"; then
        # Include non-binary files' content
        echo "File: $file" >> "$OUTPUT_FILE"
        cat "$file" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    else
        # Only include the name of binary files
        echo "Binary file: $file" >> "$OUTPUT_FILE"
    fi
done

echo "The structure and contents of the Django app have been saved to $OUTPUT_FILE"
