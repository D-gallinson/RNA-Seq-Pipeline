#!/bin/bash
#SBATCH --job-name=7_properly_aligned_count
#SBATCH --partition=margres_2020
#SBATCH --qos=margres20
#SBATCH --mail-user=youremail@usf.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/7_properly_aligned_count/%a.out
#SBATCH --error=logs/7_properly_aligned_count/%a.err
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=6G
#SBATCH --time=1-00:00:00
#SBATCH --array=0-5

################################################################
# Count the number of properly mapped alignments in each file.
# From Devon Ryan's answer: https://www.biostars.org/p/138116/
################################################################

# I/O
align_dir=../data/3_align
outdir=../results/sequencing/alignment/properly_paired_counts

# Make the outdir
mkdir -p $outdir

# Get the current file and dynamically generate output file names
file_arr=($align_dir/*.bam)
file=${file_arr[$SLURM_ARRAY_TASK_ID]}
sample=$(basename $file | cut -f1 -d".")
output=$outdir/$sample.alignment_count.txt

# Get alignment stats
samtools view -F 0x4 $file | cut -f1 | sort | uniq | wc -l > $output