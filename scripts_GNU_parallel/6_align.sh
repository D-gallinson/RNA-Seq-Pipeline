#!/bin/bash

#####################################################################
# Perform a reference-based alignment with HISAT2. This script will
# also sort the alignments and compress them to BAMs.
#####################################################################


# Picard path
export picard=${HOME}/tools/picard/build/libs/picard.jar

# Input/output dirs
# input_dir = path to the dir containing trimmed reads
# out_dir = dir path to write alignments to
# hisat2_index_base = base path to the HISAT2 index files (should be the $output path from 5..sh)
export input_dir=../data/2_trim
export out_dir=../data/3_align
export hisat2_index_base=../data/references/hisat_index_chr22/Homo_sapiens.GRCh38.dna.chromosome.22

mkdir -p $out_dir
mkdir -p logs/6_align

# Define alignment function for local parallel execution
run_align() {
    forward=$1
    
    # Get forward/reverse reads
    reverse=${forward/r1/r2}
    reverse=${reverse/val_1/val_2}

    # Pull sample name to use as output
    sample=$(basename $forward)
    sample=${sample/_r1_val_1.fq.gz/}

    # Setup explicit logging to preserve alignment stats for script 7b
    exec > logs/6_align/${sample}.out 2> logs/6_align/${sample}.err

    # Output
    sam_out=$out_dir/$sample.sam
    bam_out_sort=$out_dir/$sample.sorted.bam
    
    # Define threads per job 
    CPUS=4

    # HISAT2 to align trimmed reads
    # -p = number of threads to use (more increases speed)
    # -x = base path to the HISAT2 index files (should be the $output path from 5..sh)
    # -1 = path to the trimmed forward fastq file
    # -2 = path to the corresponding trimmed reverse fastq file
    # -S = output path
    hisat2 \
        -p $CPUS \
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
        -@ $CPUS \
        $bam_out_sort
}
export -f run_align

# Run alignment in parallel across samples (adjust -j to control concurrent jobs)
ls ${input_dir}/*r1*.fq.gz | parallel -j 2 run_align {}