#!/bin/bash

################################################################
# Use HTSeq count to generate read counts for all genes based
# on the alignments and reference genome.
################################################################


# I/O
export align_dir=../data/3_align
export outdir=../results/4_read_counts
export gtf=../data/references/Homo_sapiens.GRCh38.115.chromosome.22.gff3

# Make the output dir
mkdir -p $outdir

# Define local parallel read count function
run_htseq() {
    bam_in=$1
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
}
export -f run_htseq

# Process all BAM files in parallel using GNU parallel
ls $align_dir/*.bam | parallel -j 4 run_htseq {}