#!/bin/bash
# Function to extract tar.bz2 files
extract_tar_bz2() {
input_dir="$1"
# Check if the directory exists
if [ ! -d "$input_dir" ]; then
echo "Directory $input_dir does not exist."
exit 1
fi
# Move to the input directory
cd "$input_dir" || exit 1
# Extract each tar.bz2 file
for file in *.tar.bz2; do
tar -xf "$file"
echo "Extracted: $file"
done
}
# Main script
if [[ $# -ne 1 ]]; then
echo "Usage: $0 <directory>"
exit 1
fi
input_dir="$1"
extract_tar_bz2 "$input_dir"
