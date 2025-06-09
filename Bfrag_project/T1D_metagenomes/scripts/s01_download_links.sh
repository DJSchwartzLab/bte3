#!/bin/bash

# First, make the script executable by running: chmod +x s01_download_links.sh
# Then, run the script with the destination path as an argument: ./s01_download_links.sh T1D_metagenomes_download_links.txt /path/to/destination

# Function to download a file
download_file() {
    url="$1"
    filename=$(basename "$url")
    wget --no-check-certificate -q "$url" -P "$2"
    echo "Downloaded: $filename"
}

# Function to download links from a text file
download_links_from_file() {
    input_file="$1"
    download_dir="$2"

    # Create download directory if it doesn't exist
    mkdir -p "$download_dir"

    # Read each line in the text file
    while IFS= read -r line; do
        # Extract links from each line
        links=$(echo "$line" | grep -oP 'http[s]?://\S+')
        for link in $links; do
            download_file "$link" "$download_dir"
        done
    done < "$input_file"
}

# Main script
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <input_file> <download_dir>"
    exit 1
fi

input_file="$1"
download_dir="$2"
download_links_from_file "$input_file" "$download_dir"