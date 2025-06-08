#!/bin/bash

#==================================================================================
# File name    : s01_countreads_preprocessed.sh
# Description  : This script will loop through a directory and count the number of 
#                reads in FASTQ files.
# Usage        : sbatch s01_countreads_preprocessed.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 02/13/2025
# Last modified: 02/13/2025
#==================================================================================

# Submission script for HTCF
#SBATCH --job-name=countreads_preprocessed
#SBATCH --time=0-00:00:00 # days-hh:mm:ss
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --output=slurmout/countreads_preprocessed/x_countreads_preprocessed_%a.out
#SBATCH --error=slurmout/countreads_preprocessed/y_countreads_preprocessed_%a.err

# Define directories and output files
BASEDIR=/scratch/djslab/jltung/Bfrag_project/GG_metagenomes
INDIR=$BASEDIR/downloaded_reads
OUTDIR=$BASEDIR/countreads_preprocessed
FILENAMES=$OUTDIR/filenames.txt
COUNT_FILE=$OUTDIR/readcounts.txt

mkdir -p $OUTDIR

# Loop through each FASTQ file and count reads
for file in "$INDIR"/*FW_CLEAN.fastq; do
    echo "$(basename "$file")" >> "$FILENAMES"
    awk '{s++} END {print s/4}' "$file" >> "$COUNT_FILE"
done
