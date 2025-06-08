#!/bin/bash

#===============================================================================
# File name    : s13_bowtie2_bte3.sh
# Description  : Align reads to a pre-indexed reference sequence using Bowtie 2.
#                Designed to be run after index creation using bowtie2-build.
# Usage        : sbatch s13_bowtie2_bte3.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 02/13/2025
# Last modified: 02/13/2025
#===============================================================================

# Submission script for HTCF
#SBATCH --job-name=bowtie2
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --array=1-264
#SBATCH --output=slurmout/bowtie2_bte3/x_bowtie2_bte3_%A_%a.out
#SBATCH --error=slurmout/bowtie2_bte3/y_bowtie2_bte3_%A_%a.err

# Load Miniconda using Spack
eval $(spack load --sh miniconda3@4.10.3)

# Activate the bowtie2 Conda environment
source activate bowtie2

#Define paths
BASEDIR=/scratch/djslab/jltung/Bfrag_project
READSDIR=${BASEDIR}/MetaHIT_metagenomes/bbmap_repaired
SAMPLE=`sed -n ${SLURM_ARRAY_TASK_ID}p ${BASEDIR}/MetaHIT_metagenomes/MetaHIT_metagenomes_mappingfile.txt`
REF=bte3
REF_INDEX=${BASEDIR}/bte_reference_sequences/${REF}/${REF} # Specify the full path to the index prefix

OUTDIR=${BASEDIR}/MetaHIT_metagenomes/bowtie2_${REF}/${SAMPLE}_${REF}

# Make output directory
mkdir -p ${OUTDIR}

# Run Bowtie 2
time bowtie2 -p ${SLURM_CPUS_PER_TASK} \
    -x ${REF_INDEX} \
    -S ${OUTDIR}/${SAMPLE}_mappedreads.sam \
    -1 ${READSDIR}/${SAMPLE}_FW_CLEAN_REPAIRED.fastq \
    -2 ${READSDIR}/${SAMPLE}_RV_CLEAN_REPAIRED.fastq

RC=$?

if [ "$RC" -eq 0 ]; then
    echo "Bowtie2 alignment for ${SAMPLE} completed successfully."
else
    echo "Bowtie2 alignment for ${SAMPLE} failed with exit code $RC."
    exit $RC
fi