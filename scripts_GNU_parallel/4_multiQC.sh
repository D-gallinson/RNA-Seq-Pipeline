#!/bin/bash

###########################################################################
# Combine the post-trimming report files generated from TrimGalore! using
# multiQC. 
###########################################################################


# IO
# fastq_trim_dir = path to the dir containing all trimmed fastq's
# fastqc_in = path to store the sample-level fastQC reports for trimmed reads
# fastqc_in = path to store the combined multiQC report across all fastQC reports
# trim_in = path to store the sample-level trimming reports for trimmed reads
# trim_in = path to store the combined multiQC report across all trimming reports
fastq_trim_dir=../data/2_trim
fastqc_in=../results/sequencing/fastQC/post_trim/fastqc_files
fastqc_out=../results/sequencing/fastQC/post_trim
trim_in=../results/sequencing/trimming/trimming_files
trim_out=../results/sequencing/trimming

# Make the output dirs
mkdir -p $fastqc_in
mkdir -p $trim_in

# Move the TrimGalore! reporting files to their appropriate input dirs
mv $fastq_trim_dir/*fastqc* $fastqc_in
mv $fastq_trim_dir/*trimming_report* $trim_in

# Combined fastQC reports
~/tools/multiqc/bin/./multiqc \
    -n postQC_multi \
    -o $fastqc_out \
    $fastqc_in

# Combined trimming report
~/tools/multiqc/bin/./multiqc \
    -n trimming_multi \
    -o $trim_out \
    $trim_in