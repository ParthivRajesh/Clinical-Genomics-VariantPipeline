# PIPELINE (Makeshift)
# You can try it out yourself ;D

## CODE STARTS HERE --->

# Set working directories
WORKDIR=~/genomics_pipeline
RAW_DIR=$WORKDIR/raw_data
QC_DIR=$WORKDIR/qc_reports
TRIM_DIR=$WORKDIR/trimmed
ALIGN_DIR=$WORKDIR/alignment
SNPEFF_DIR=$WORKDIR/snpeff
REF=$WORKDIR/reference/GRCh38.fa
SNPEFF_GENOME=GRCh38.99

mkdir -p $QC_DIR $TRIM_DIR $ALIGN_DIR $SNPEFF_DIR

# FastQC to check quality
fastqc -o $QC_DIR $RAW_DIR/*.fastq

# Trim the Reads
trimmomatic SE -phred33 \
    $RAW_DIR/SRR576933.fastq \
    $TRIM_DIR/SRR576933_trimmed.fastq \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

# Index Reference Genome (only once)
bwa index $REF
samtools faidx $REF
samtools dict $REF -o ${REF/.fa/.dict}

# BWA Alignment
bwa mem $REF $TRIM_DIR/SRR576933_trimmed.fastq > $ALIGN_DIR/SRR576933.sam

# Convert SAM to BAM
samtools view -Sb $ALIGN_DIR/SRR576933.sam > $ALIGN_DIR/SRR576933.bam

# Sort BAM
samtools sort $ALIGN_DIR/SRR576933.bam -o $ALIGN_DIR/SRR576933.sorted.bam

# Index BAM
samtools index $ALIGN_DIR/SRR576933.sorted.bam

# Variant Calling (BCFtools)
bcftools mpileup -f $REF $ALIGN_DIR/SRR576933.sorted.bam | \
    bcftools call -mv -Ov -o $ALIGN_DIR/SRR576933.raw.vcf

# Filter variants
bcftools filter -s LOWQUAL -e '%QUAL<20 || DP<10' $ALIGN_DIR/SRR576933.raw.vcf > $ALIGN_DIR/filtered_variants.vcf

# Annotate with SnpEff
cd $SNPEFF_DIR
java -Xmx4g -jar snpEff.jar $SNPEFF_GENOME $ALIGN_DIR/filtered_variants.vcf > output.ann.vcf


echo " Pipeline complete! Annotated VCF is at $SNPEFF_DIR/output.ann.vcf" ( You can use nano for this, or command-line itself )


## CODE ENDS HERE...
