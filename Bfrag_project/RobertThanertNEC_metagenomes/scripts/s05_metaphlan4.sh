#!/bin/bash

#===============================================================================
# File name    : s08_metaphlan4.sh
# Description  : Profiles taxonomic composition of a read set using MetaPhlAn 4.
# Usage        : sbatch s08_metaphlan4.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 02/13/2025
# Last modified: 02/13/2025
#===============================================================================

# Submission script for HTCF
#SBATCH --job-name=metaphlan4
#SBATCH --array=1-2111
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --output=slurmout/metaphlan4/x_metaphlan4_%a_%A.out
#SBATCH --error=slurmout/metaphlan4/y_metaphlan4_%a_%A.err

# Note: Multiple versions of MetaPhlAn are installed — run `spack find py-metaphlan` to list them.
eval $( spack load --sh py-metaphlan@4.0.2 )

# Define directories
BASEDIR="/scratch/djslab/jltung/Bfrag_project/RobertThanertNEC_metagenomes"
INDIR="${BASEDIR}/bbmap_repaired"
OUTDIR="${BASEDIR}/metaphlan4"

#Create output directory if it doesn't exist
mkdir -p ${OUTDIR}

# Get sample name from mapping file
sample=`sed -n ${SLURM_ARRAY_TASK_ID}p ${BASEDIR}/RobertThanertNEC_metagenomes_mappingfile.txt`

# Run MetaPhlAn 4
set -x
time metaphlan \
  ${INDIR}/${sample}_FW_CLEAN_REPAIRED.fastq,${INDIR}/${sample}_RV_CLEAN_REPAIRED.fastq \
 --input_type fastq \
  --bowtie2db /ref/djslab/data/metaphlan4_db \
  --bowtie2out ${OUTDIR}/${sample}.bowtie2.bz2 \
  -o ${OUTDIR}/${sample}_profile.txt \
  --nproc ${SLURM_CPUS_PER_TASK} \
  --index mpa_vOct22_CHOCOPhlAnSGB_202212 \
  --read_min_len 40
RC=$?
set +x

# Check for success
if [ $RC -eq 0 ]
then
  echo "Job completed successfully for ${sample}"
else
  echo "Error occurred in ${sample}!"
  exit $RC
fi