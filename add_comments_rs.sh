#!/bin/bash

# Starting directory
start_dir="./contracts"

# Function to process files
process_files() {
  local dir=$1
  for file in "$dir"/*; do
    if [ -d "$file" ]; then
      # If directory, recurse
      process_files "$file"
    elif [[ $file == *.cairo ]]; then
      # If Cairo file
      local rel_path=${file#"$start_dir"/}  # Get relative path
      
      # Remove any existing // File: comments
      sed -i '' '/^\/\/ File: /d' "$file"
      
      # Prepend the correct // File: comment
      awk -v comment="// File: $rel_path" '
        BEGIN {print comment}
        {print}
      ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    fi
  done
}

# Run function from starting directory
process_files "$start_dir"
