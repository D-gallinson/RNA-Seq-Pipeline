#!/bin/bash

####################################################################################
# This script generates HISAT2 index files. I have included code to generate splice
# sites and exons which can also be included in the index generation, although this
# is not necessary. 
####################################################################################

# I/O
# fasta = path to the genome assembly (i.e., fasta file of nucleotides)
# gtf = path to the genome reference (i.e., GTF or GFF showing genomic positions of genes)
# outdir = path to the output dir
# output = full path to the output (this should be $outdir/my_out_names and should NOT include a file extension)
fasta=../data/references/Homo_sapiens.GRCh38.dna.chromosome.22.fa
gtf=../data/references/Homo_sapiens.GRCh38.115.chr.gtf.gz
outdir=../data/references/hisat_index_chr22
output=$outdir/Homo_sapiens.GRCh38.dna.chromosome.22

# Make the output dir
mkdir -p $outdir

# Define local CPU core count
CPUS=8

# Generate ss and exon files
# hisat2_extract_splice_sites.py $gtf > ${output}.ss
# hisat2_extract_exons.py $gtf > ${output}.exon

# Build the HFM index
hisat2-build -p $CPUS $fasta $output