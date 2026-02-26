# Reference-Based RNA-seq Alignment Pipeline

An example reference-based RNA-seq alignment pipeline using a toy cancer dataset of lung cancer versus normal tissue samples (courtesy of The Griffith Lab RNA-seq Tutorial: [https://rnabio.org/](https://rnabio.org/)). The basic steps of the pipeline are as follows:

### Pipeline Steps

1. Download raw reads
2. Raw read QC (FastQC and MultiQC)
3. Read trimming (TrimGalore!)
4. Post-trimming QC (MultiQC)
5. Build index (HISAT2)
6. Read alignment (HISAT2)
7. Alignment statistics (custom scripts to aggregate log files from HISAT2)
8. Read counting (HTSeq)
9. Differential expression (DESeq2)

---

### Pipeline Versions

Three versions of the pipeline exist, each of which perform identical steps but go about these steps in slightly different ways:

* **`scripts_GNU_parallel`**: uses GNU parallel to parallelize processing samples where possible. Ideal for running the pipeline on local hardware.
* **`scripts_SLURM_parallel`**: uses a SLURM scheduler to parallelize processing samples where possible. Ideal for running the pipeline on most clusters.
* **`scripts_serial`**: processes all samples in serial. The slowest option but the most straightforward to run.

---

### Usage & Assumptions

For most applications, each of the three pipeline versions can be run simply by changing input/output paths in all scripts. A relevant reference genome (fasta and gtf/gff) are also required.

Each pipeline assumes you are CD'ed into the `scripts/` directory before execution. It is also assumed that the following directory structure exists:

```text
.
├── scripts/
│   └── logs/
│       ├── 3_trim/
│       ├── 6_align/
│       ├── 7_properly_aligned_count/
│       └── 8_count_reads/
├── results/
│   └── sequencing/
└── data/
    ├── 1_fastq/
    ├── 2_trim/
    ├── 3_align/
    ├── 4_read_counts/
    └── references/

```

---

### Dependencies

The following dependencies are necessary:

* **GNU Parallel**: For parallel processing of samples locally (required for the `scripts_GNU_parallel` pipeline).
* **SRA Toolkit / wget & tar**: For downloading and extracting the initial dataset.
* **FastQC**: For generating quality control reports of the raw and trimmed reads.
* **MultiQC**: For aggregating FastQC and trimming reports (requires Python).
* **Trim Galore!**: For adapter and quality trimming (this also requires **Cutadapt** to be installed).
* **HISAT2**: For building the reference genome index and aligning the trimmed reads.
* **Picard Tools**: For sorting the aligned `.sam` files into `.bam` files (requires **Java**).
* **Samtools**: For indexing `.bam` files and extracting alignment statistics.
* **HTSeq**: Specifically `htseq-count` for generating read counts based on the reference genome.
* **DESeq2**: An R package required for the final differential expression analysis.
