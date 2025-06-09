#!/bin/bash

#===============================================================================
# File name    : s05_deconseq.sh
# Description  : Run DeconSeq against the human genome.
# Usage        : sbatch s05_deconseq.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 01/21/2025
# Last modified: 01/21/2025
#===============================================================================

# Submission script for HTCF
#SBATCH --job-name=deconseq
#SBATCH --array=1-812
#SBATCH --time=3-00:00:00 #days-hh:mm:ss
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --output=slurmout/deconseq/x_deconseq_%a.out
#SBATCH --error=slurmout/deconseq/y_deconseq_%a.err

# Load DeconSeq module
# Loading from Schwartz lab Spack instance the associated DeconSeq configuration file below has been edited to:
#  1.) point to the Dantas Lab ref DB folder: /ref/gdlab/data/deconseq_db,
#  2.) recognize that the DB folder contains database files for the mouse genome and archaeal genomes, and not just the human, bacterial, and viral genomes that are default available databases
#. 3.) point to the correct directory for bwa64 executable.
# /ref/djslab/software/spack-0.18.1/opt/spack/linux-rocky8-x86_64/gcc-8.5.0/deconseq-standalone-0.4.3-ikgqjmgyy4sujmjugkfw7yik4mnrwe6m/De$
# Use command: deconseq.pl -show_dbs to see the available databases (mouse, hsref, arch, bact, vir in the Schwartz lab)
eval "$( spack load --sh deconseq-standalone@0.4.3 )"

# Define input/output directories
INDIR="/scratch/djslab/jltung/Bfrag_project/TCC_metagenomes/trimmed"
OUTDIR="/scratch/djslab/jltung/Bfrag_project/TCC_metagenomes/deconseq_out"

# Create output directory if it doesn't exist
mkdir -p ${OUTDIR}

# Samples for slurm array
ID=`sed -n ${SLURM_ARRAY_TASK_ID}p /scratch/djslab/jltung/Bfrag_project/TCC_metagenomes/TCC_metagenomes_mappingfile.txt`

# Run deconseq on forward paired reads, filtering out human genome
deconseq.pl \
-f ${INDIR}/${ID}_FW_CLEAN.fastq \
-out_dir ${OUTDIR} \
-id ${ID}_FW_CLEAN \
-dbs hsref \
-t 8

# Run deconseq on reverse paired reads, filtering out human genome
deconseq.pl \
-f ${INDIR}/${ID}_RV_CLEAN.fastq \
-out_dir ${OUTDIR} \
-id ${ID}_RV_CLEAN \
-dbs hsref \
-t 8

# Print
echo $ID completed