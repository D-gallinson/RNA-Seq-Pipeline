#!/bin/bash

###########################################################################
# Based on the fastQC/multiQC generated in the previous step, trim all
# fastq files.
###########################################################################

# I/O
# input_dir = path to the input dir containing raw (compressed) fastq's (expected to be in fastq.gz format, NOT fq.gz)
# output = path to the output dir where all trimmed fastq files will be written
input_dir=../data/1_fastq
output=../data/2_trim

mkdir -p $output

# Loop through all R1 reads in $input_dir serially. 
# The PE R2 read is generated through string replacement.
for forward in ${input_dir}/*r1*.fastq.gz; do
    reverse=${forward/r1/r2}

    #Trimming and FastQC
    trim_galore \
        --quality 30 \
        --length 75 \
        --fastqc \
        --paired \
        -o $output \
        $forward $reverse
done