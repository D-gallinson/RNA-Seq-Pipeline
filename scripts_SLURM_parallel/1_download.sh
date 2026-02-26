#!/bin/bash
#SBATCH --job-name=1_download
#SBATCH --partition=margres_2020
#SBATCH --qos=margres20
#SBATCH --mail-user=youremail@usf.edu
#SBATCH --mail-type=END,FAIL
#SBATCH --output=logs/1_download.out
#SBATCH --error=logs/1_download.err
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --time=1-00:00:00

####################################
# Basic script to download data
####################################

module add apps/sratoolkit/2.10.7

# Download human/cancer data for reference-based pipeline (from The Griffith Lab RNA-seq Tutorial: https://rnabio.org/)
wget -P ../data/1_fastq/humans http://genomedata.org/rnaseq-tutorial/practical.tar

# Extract it
tar -xvf ../data/1_fastq/humans/practical.tar
