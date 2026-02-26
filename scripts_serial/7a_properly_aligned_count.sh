#!/bin/bash

################################################################
# Count the number of properly mapped alignments in each file.
# From Devon Ryan's answer: https://www.biostars.org/p/138116/
################################################################

# I/O
align_dir=../data/3_align
outdir=../results/sequencing/alignment/properly_paired_counts

# Make the outdir
mkdir -p $outdir

# Loop serially through BAM files to count properly mapped alignments
for file in $align_dir/*.bam; do
    
    # Process the current file and dynamically generate output file names
    sample=$(basename $file | cut -f1 -d".")
    output=$outdir/$sample.alignment_count.txt

    # Get alignment stats
    samtools view -F 0x4 $file | cut -f1 | sort | uniq | wc -l > $output
done