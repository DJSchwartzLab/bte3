#!/usr/bin/env python3
"""
extract_bowtie2_summary.py

This script processes all .err files in a specified directory, extracts:
  - The number before '.err' in each filename (e.g., 1 in y_bowtie2_bte2_23272412_1.err)
  - The first number on the 4th line of each file

It writes these values into a CSV file with two columns:
  - "array"
  - "# of reads aligned concordantly exactly 1 time"

Usage:
    python extract_bowtie2_summary.py /path/to/err/files output.csv

The output file will be saved in the same directory as the .err files.
"""

import os
import csv
import re
import argparse

def extract_data_from_err_files(directory, output_filename):
    data = []

    for filename in os.listdir(directory):
        if filename.endswith(".err"):
            # Extract the number before .err using regex
            match = re.search(r'_(\d+)\.err$', filename)
            if match:
                array_number = match.group(1)

                file_path = os.path.join(directory, filename)
                try:
                    with open(file_path, 'r') as f:
                        lines = f.readlines()
                        if len(lines) >= 4:
                            fourth_line = lines[3]
                            # Extract the first number on the 4th line
                            number_match = re.search(r'\d+', fourth_line)
                            if number_match:
                                aligned_reads = number_match.group(0)
                            else:
                                aligned_reads = "N/A"
                        else:
                            aligned_reads = "N/A"

                    data.append([array_number, aligned_reads])
                except Exception as e:
                    print(f"Error reading {filename}: {e}")

    # Build full output path in the input directory
    output_path = os.path.join(directory, output_filename)

    # Write to CSV with appropriate headers
    with open(output_path, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["array", "# of reads aligned concordantly exactly 1 time"])
        writer.writerows(data)

    print(f"Output written to: {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract summary data from Bowtie2 .err files.")
    parser.add_argument("input_directory", help="Path to the directory containing .err files")
    parser.add_argument("output_filename", help="Name of the output CSV file (e.g., summary.csv)")

    args = parser.parse_args()
    
    extract_data_from_err_files(args.input_directory, args.output_filename)
