#!/bin/bash

####################################
# Basic script to download data
####################################

# Download human/cancer data for reference-based pipeline (from The Griffith Lab RNA-seq Tutorial: https://rnabio.org/)
wget -P ../data/1_fastq/humans http://genomedata.org/rnaseq-tutorial/practical.tar

# Extract it
tar -xvf ../data/1_fastq/humans/practical.tar