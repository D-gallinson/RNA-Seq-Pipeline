#!/bin/bash
#SBATCH --job-name=8_count_reads
#SBATCH --partition=margres_2020
#SBATCH --qos=margres20
#SBATCH --mail-user=youremail@usf.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/8_count_reads/%a.out
#SBATCH --error=logs/8_count_reads/%a.err
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=20G
#SBATCH --time=24:00:00
#SBATCH --array=0-5

################################################################
# Use HTSeq count to generate read counts for all genes based
# on the alignments and reference genome.
################################################################

# Using HTSeq version 2.0.3
source $HOME/.start_conda
conda activate RNA-seq

# I/O
align_dir=../data/3_align
outdir=../results/4_read_counts
gtf=../data/references/Homo_sapiens.GRCh38.115.chromosome.22.gff3

# Make the output dir
mkdir -p $outdir

# Generate the input and output paths
bam_arr=($align_dir/*.bam)
bam_in=${bam_arr[$SLURM_ARRAY_TASK_ID]}
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
