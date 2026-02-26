#!/bin/bash

################################################################
# Count the number of properly mapped alignments in each file.
# From Devon Ryan's answer: https://www.biostars.org/p/138116/
################################################################

# I/O
export align_dir=../data/3_align
export outdir=../results/sequencing/alignment/properly_paired_counts

# Make the outdir
mkdir -p $outdir

# Define function to count properly mapped alignments for local parallel execution
count_alignments() {
    file=$1
    # Process the current file and dynamically generate output file names
    sample=$(basename $file | cut -f1 -d".")
    output=$outdir/$sample.alignment_count.txt

    # Get alignment stats
    samtools view -F 0x4 $file | cut -f1 | sort | uniq | wc -l > $output
}
export -f count_alignments

# Process all BAM files in parallel
ls $align_dir/*.bam | parallel -j 4 count_alignments {}