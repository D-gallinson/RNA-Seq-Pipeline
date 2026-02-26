#!/bin/bash

###########################################################################
# Generate fastQC reports for all raw fastq files and combine the reports
###########################################################################


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

# Combine FastQC reports
~/tools/multiqc/bin/./multiqc \
    -n preQC_multi \
    -o $output \
    $output/fastqc_files