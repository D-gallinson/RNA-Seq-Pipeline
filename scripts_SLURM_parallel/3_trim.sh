#!/bin/bash
#SBATCH --job-name=3_trim
#SBATCH --partition=margres_2020
#SBATCH --qos=margres20
#SBATCH --mail-user=youremail@usf.edu
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output=logs/3_trim/%a.out
#SBATCH --error=logs/3_trim/%a.err
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=7900M
#SBATCH --time=7-00:00:00
#SBATCH --array=0-5

###########################################################################
# Based on the fastQC/multiQC generated in the previous step, trim all
# fastq files.
###########################################################################

module purge
module add apps/trimgalore/0.4.4

# I/O
# input_dir = path to the input dir containing raw (compressed) fastq's (expected to be in fastq.gz format, NOT fq.gz)
# output = path to the output dir where all trimmed fastq files will be written
input_dir=../data/1_fastq
output=../data/2_trim

#Generate an array of all R1 reads in $input_dir. The PE R2 read is generated through string replacement
forward_array=(${input_dir}/*r1*.fastq.gz)
forward=${forward_array[$SLURM_ARRAY_TASK_ID]}
reverse=${forward/r1/r2}

#Trimming and FastQC
trim_galore \
    --quality 30 \
    --length 75 \
    --fastqc \
    --paired \
    -o $output \
    $forward $reverse
