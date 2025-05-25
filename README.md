#  Variant Calling & Annotation Pipeline for Human Genomic Data

## Project Description
This document demonstrates a complete variant calling and annotation pipeline that starts with FastQ datasets. The pipeline utilizes open-source bioinformatic programs to process resulting reads, align them to the human genome (GRCh38), call genetic variants, and functionally annotate them. 

The pipeline imitates a ClinGen workflow and includes all necessary steps—quality control, adapter trimming, alignment, variant calling, filtering, and annotation—using existing command line tools.

---

## Problem Statement
To perform quality control, alignment, variant calling, filtering, and annotation on sequencing data from SRR576933 using tools like FastQC, BWA, SAMtools, bcftools, and SnpEff.

---

## Workflow and Tools

- **Data Source**: Public FASTQ dataset (SRR576933) from SRA.
- **Reference Genome**: GRCh38 from GENCODE.
- **Tools Used**:
  - `FastQC` – Read quality control
  - `Trimmomatic` – Adapter and low-quality trimming
  - `HISAT2` – Read alignment to reference genome
  - `SAMtools` – Format conversion and sorting
  - `bcftools` – Variant calling and filtering
  - `SnpEff` – Variant annotation

---

## Results

### Output Files:
| File Name                          | Description                             |
|-----------------------------------|-----------------------------------------|
| `SRR576933_trimmed.fastq`         | Trimmed high-quality reads              |
| `SRR576933_sorted.bam`            | Sorted alignment file                   |
| `variants.vcf`                    | Raw variants called                     |
| `filtered_variants.vcf`           | Filtered variants (QUAL ≥ 20, DP ≥ 10)  |
| `annotated_filtered_variants.vcf` | Functionally annotated variant set      |


---

## Repository Contents

- `raw_data/`: Original FASTQ file
- `ref/`: GRCh38 reference genome and index files
- `trimmed/`: Cleaned reads after Trimmomatic
- `alignment/`: BAM files, variant calls, and sorted data
- `snpeff/`: Annotated VCF output from SnpEff
- `scripts/`: Shell commands and helper scripts used

---

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/ParthivRajesh/Genomics-Pipeline-Variant-Calling.git
   cd Genomics-Pipeline-Variant-Calling
