#!/bin/bash

###########################################################################
# Based on the fastQC/multiQC generated in the previous step, trim all
# fastq files.
###########################################################################


# I/O
# input_dir = path to the input dir containing raw (compressed) fastq's (expected to be in fastq.gz format, NOT fq.gz)
# output = path to the output dir where all trimmed fastq files will be written
export input_dir=../data/1_fastq
export output=../data/2_trim

mkdir -p $output

# Define trimming function for local parallel execution
run_trim() {
    forward=$1
    # Process R1 reads. The PE R2 read is generated through string replacement
    reverse=${forward/r1/r2}

    #Trimming and FastQC
    trim_galore \
        --quality 30 \
        --length 75 \
        --fastqc \
        --paired \
        -o $output \
        $forward $reverse
}
export -f run_trim

# Run trimming in parallel (adjust -j based on your local system's cores)
ls ${input_dir}/*r1*.fastq.gz | parallel -j 4 run_trim {}