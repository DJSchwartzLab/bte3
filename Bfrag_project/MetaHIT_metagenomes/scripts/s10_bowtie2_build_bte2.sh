#!/bin/bash

#===============================================================================
# File name    : s10_bowtie2_build_bte2.sh
# Description  : This script creates an index from a reference FASTA file (bte2.fasta)
#                using bowtie2-build.
# Usage        : sbatch s10_bowtie2_build_bte2.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 02/13/2025
# Last modified: 02/13/2025
#===============================================================================

# Submission script for HTCF
#SBATCH --job-name=bowtie2_build_bte2
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --output=slurmout/bowtie2_build_bte2/%x_%j.out
#SBATCH --error=slurmout/bowtie2_build_bte2/%x_%j.err

# Load Miniconda using Spack
eval $(spack load --sh miniconda3@4.10.3)

# Activate the bowtie2 Conda environment
source activate bowtie2

#Define directories
BASEDIR=/scratch/djslab/jltung/Bfrag_project/bte_reference_sequences

# Define reference FASTA file and index base name
REF=${BASEDIR}/bte2/bte2.fasta
INDEX_BASE=${REF%.fasta}

echo "Building Bowtie2 index for reference: ${REF}"
bowtie2-build --threads ${SLURM_CPUS_PER_TASK} "${REF}" "${INDEX_BASE}"

if [ $? -ne 0 ]; then
    echo "Error: Bowtie2 index build failed!"
    exit 1
else
    echo "Bowtie2 index built successfully."
fi
