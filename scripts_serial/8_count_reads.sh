#!/bin/bash

################################################################
# Use HTSeq count to generate read counts for all genes based
# on the alignments and reference genome.
################################################################

# I/O
align_dir=../data/3_align
outdir=../results/4_read_counts
gtf=../data/references/Homo_sapiens.GRCh38.115.chromosome.22.gff3

# Make the output dir
mkdir -p $outdir

# Loop serially through BAM files to process read counts
for bam_in in $align_dir/*.bam; do
    
    # Generate the input and output paths
    sample=$(basename $bam_in)
    sample=${sample/.sorted.bam/}
    output=$outdir/$sample.tsv

    # Count reads within venom regions using HTSeq-count
    htseq-count \
        --nprocesses=2 \
        --type=gene \
        --stranded=no \
        --order=pos \
        --nonunique=all \
        --minaqual 10 \
        --counts_output=$output \
        $bam_in \
        $gtf
done