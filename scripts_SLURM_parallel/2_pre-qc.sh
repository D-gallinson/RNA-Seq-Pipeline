#!/bin/bash
#SBATCH --job-name=2_pre-qc
#SBATCH --partition=margres_2020
#SBATCH --qos=margres20
#SBATCH --mail-user=youremail@usf.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=logs/2_pre-qc.out
#SBATCH --error=logs/2_pre-qc.err
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=7-00:00:00

###########################################################################
# Generate fastQC reports for all raw fastq files and combine the reports
###########################################################################

module purge
module add apps/fastqc/0.11.5

# I/O
# input = path to the input dir containing raw (compressed) fastq's (expected to be in fastq.gz format, NOT fq.gz)
# output = path directory where the fastQC and multiQC reports will be written to
input=../data/1_fastq/*.fastq.gz
output=../results/sequencing/fastQC/pre_trim

# Make all output dirs
mkdir -p $output/fastqc_files

# FastQC
fastqc \
    -t 4 \
    $input \
    -o $output/fastqc_files

# Necessary to prevent conflict between loading FastQC (which loads python2.7) and multiqc
module purge
module add apps/python/3.8.5

# Combine FastQC reports
~/tools/multiqc/bin/./multiqc \
    -n preQC_multi \
    -o $output \
    $output/fastqc_files