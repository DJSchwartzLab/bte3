#!/bin/bash

#==================================================================================
# File name    : s02_fastqc_preprocessed.sh
# Description  : This script will run FastQC on samples in parallel.
# Usage        : sbatch s02_fastqc_preprocessed.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 02/13/2025
# Last modified: 02/13/2025
#==================================================================================

#Submission script for HTCF
#SBATCH --job-name=fastqc_preprocessed
#SBATCH --array=1-2111
#SBATCH --time=0-06:00:00 # days-hh:mm:ss
#SBATCH --mem=8G
#SBATCH --output=slurmout/fastqc_preprocessed/x_fastqc_preprocessed_%a.out
#SBATCH --error=slurmout/fastqc_preprocessed/y_fastqc_preprocessed_%a.err

# Load FastQC module
eval $(spack load --sh fastqc@0.12.1)

# Define input/output directories
BASEDIR="/scratch/djslab/jltung/Bfrag_project/RobertThanertNEC_metagenomes"
INDIR="${BASEDIR}/downloaded_reads"
OUTDIR="${BASEDIR}/fastqc_preprocessed"

#Create output directory if it doesn't exist
mkdir -p ${OUTDIR}

#Get sample names from mapping file
sample=`sed -n ${SLURM_ARRAY_TASK_ID}p ${BASEDIR}/RobertThanertNEC_metagenomes_mappingfile.txt`

# Run FastQC on both forward and reverse reads
set -x
time fastqc ${INDIR}/${sample}_R1_CLEAN.fastq ${INDIR}/${sample}_R2_CLEAN.fastq -o ${OUTDIR}
RC=$?
set +x

#Check for success or failure
if [ $RC -eq 0 ]
then
  echo "Job completed successfully for ${sample}"
else
  echo "Error Occured in ${sample}!"
  exit $RC
fi
