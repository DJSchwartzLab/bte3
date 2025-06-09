#!/bin/bash

#==========================================================================================================================
# File name  : s04_trimmomatic.sh
# Description: Trims adapter sequences and low-quality bases from Illumina reads, producing a "cleaned" set of paired reads.
# Usage      : sbatch s04_trimmomatic.sh
# Author     : Jessica Tung, j.l.tung@wustl.edu
# Version    : 1.0
# Created on : 02/13/2025
# Modified on: 02/13/2025
#==========================================================================================================================

# Submission script for HTCF
#SBATCH --job-name=trimmomatic
#SBATCH --array=1-812
#SBATCH --mem=1G
#SBATCH --output=slurmout/trimmomatic/x_trim_%a_%A.out
#SBATCH --error=slurmout/trimmomatic/y_trim_%a_%A.err

eval $( spack load --sh trimmomatic@0.39)

BASEDIR="/scratch/djslab/jltung/Bfrag_project/TCC_metagenomes"
INDIR="${BASEDIR}/downloaded_reads"
OUTDIR="${BASEDIR}/trimmed"

mkdir -p ${OUTDIR}

# Need to declare memory explicitely
export JAVA_ARGS="-Xmx1000M"

# Choose which adapters to use:
  ## NexteraPE-PE.fa,
  ## TruSeq2-PE.fa, TruSeq2-SE.fa,
  ## TruSeq3-PE-2.fa, TruSeq3-PE.fa, TruSeq3-SE.fa
adapt="/ref/djslab/data/trimmomatic_adapters/0.39/NexteraPE-PE.fa"

# TCC_metagenomes_mappingfile.txt contains a list of all file names
sample=`sed -n ${SLURM_ARRAY_TASK_ID}p ${BASEDIR}/TCC_metagenomes_mappingfile.txt`
# R1 = FWW and R2 = RV
# P = paired, UP = unpaired

set -x
time trimmomatic \
PE \
-phred33 \
-trimlog \
${OUTDIR}/Paired_${sample}_trimlog.txt \
${INDIR}/${sample}_pe_1.fastq \
${INDIR}/${sample}_pe_2.fastq \
${OUTDIR}/${sample}_FW_CLEAN.fastq \
${OUTDIR}/${sample}_FW_CLEAN_UP.fastq \
${OUTDIR}/${sample}_RV_CLEAN.fastq \
${OUTDIR}/${sample}_RV_CLEAN_UP.fastq \
ILLUMINACLIP:${adapt}:2:30:10:1:true \
SLIDINGWINDOW:4:15 \
LEADING:10 \
TRAILING:10 \
MINLEN:60
RC=$?
set +x