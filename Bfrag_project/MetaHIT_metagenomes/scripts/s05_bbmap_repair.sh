#!/bin/bash

#===================================================================================
# File name    : s05_bbmap_repair.sh
# Description  : This script will fix paired ends in parallel using repair.sh from
#                bbmap. For use after Trimmomatic, Deconseq. MetaPhlAn does not use
#                paired read information (just all reads concatenated), but if other
#                analyses will be done, it may be necessary to re-pair paired reads.
#                Good practice to always run.
# Usage        : sbatch s05_bbmap_repair.sh
# Author       : Jessica Tung (j.l.tung@wustl.edu)
# Version      : 1.0
# Created on   : 02/13/2025
# Last modified: 02/13/2025
#===================================================================================

#Submission script for HTCF
#SBATCH --job-name=bbmap_repair
#SBATCH --array=1-264
#SBATCH --time=6-00:00:00 #days-hh:mm:ss
#SBATCH --mem=16G
#SBATCH --output=slurmout/bbmap_repair/x_bbmap_repair_%a.out
#SBATCH --error=slurmout/bbmap_repair/y_bbmap_repair_%a.err

#Load BBmap module
eval $(spack load --sh bbmap@39.01)

#Define input and output directories
BASEDIR="/scratch/djslab/jltung/Bfrag_project/MetaHIT_metagenomes"
INDIR="${BASEDIR}/downloaded_reads"
OUTDIR="${BASEDIR}/bbmap_repaired"
OUTDIR2="${BASEDIR}/bbmap_repaired_singletons"

#Get sample ID from mapping file
ID=`sed -n ${SLURM_ARRAY_TASK_ID}p ${BASEDIR}/MetaHIT_metagenomes_mappingfile.txt`

#Run repair
repair.sh --tossbrokenreads \
    in1=${INDIR}/${ID}_1.fastq \
    in2=${INDIR}/${ID}_2.fastq \
    out1=${OUTDIR}/${ID}_FW_CLEAN_REPAIRED.fastq \
    out2=${OUTDIR}/${ID}_RV_CLEAN_REPAIRED.fastq \
    outs=${OUTDIR2}/${ID}_SINGLETONS_CLEAN_REPAIRED.fastq.gz