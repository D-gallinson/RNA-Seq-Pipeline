#!/bin/bash
#SBATCH --job-name=6_align
#SBATCH --partition=margres_2020
#SBATCH --qos=margres20
#SBATCH --mail-user=youremail@usf.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/6_align/%a.out
#SBATCH --error=logs/6_align/%a.err
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=15G
#SBATCH --time=7-00:00:00
#SBATCH --array=0-5

#####################################################################
# Perform a reference-based alignment with HISAT2. This script will
# also sort the alignments and compress them to BAMs.
#####################################################################

source $HOME/.start_conda
conda activate RNA-seq

# Picard path
picard=${HOME}/tools/picard/build/libs/picard.jar

# Input/output dirs
# input_dir = path to the dir containing trimmed reads
# out_dir = dir path to write alignments to
# hisat2_index_base = base path to the HISAT2 index files (should be the $output path from 5..sh)
input_dir=../data/2_trim
out_dir=../data/3_align
hisat2_index_base=../data/references/hisat_index_chr22/Homo_sapiens.GRCh38.dna.chromosome.22

# Get forward/reverse reads
forward_array=(${input_dir}/*r1*.fq.gz)
forward=${forward_array[$SLURM_ARRAY_TASK_ID]}
reverse=${forward/r1/r2}
reverse=${reverse/val_1/val_2}

# Pull sample name to use as output
sample=$(basename $forward)
sample=${sample/_r1_val_1.fq.gz/}

# Output
sam_out=$out_dir/$sample.sam
bam_out_sort=$out_dir/$sample.sorted.bam


# HISAT2 to align trimmed reads
# -p = number of threads to use (more increases speed)
# -x = base path to the HISAT2 index files (should be the $output path from 5..sh)
# -1 = path to the trimmed forward fastq file
# -2 = path to the corresponding trimmed reverse fastq file
# -S = output path
hisat2 \
	-p $SLURM_CPUS_PER_TASK \
	-x $hisat2_index_base \
	-1 $forward \
	-2 $reverse \
	-S $sam_out


#Generate sorted BAMs
java -jar $picard SortSam \
    INPUT=${sam_out} \
    OUTPUT=${bam_out_sort} \
    SORT_ORDER=coordinate

rm $sam_out


# Generate bam index
samtools index \
	-@ $threads \
	$bam_out_sort
