#!/bin/bash

#SBATCH --time=72:00:00
#SBATCH --mem=16gb

echo $1,$2


# $1 = SRA Accession
# $2 = Sample_Name
ref=./refgenomes/GCA_023338255.1_SBiKF_Bphy_ph2_genomic.fna

### Load Modules
module load sra
module load bowtie2
module load samtools
module load picard

### Create Directories
mkdir SRA_DLs
mkdir BAM_Files

### Download files
fasterq-dump $1 --split-files -O ./SRA_DLs -t ./temp_dir

### Merge Reads
./SeqPrep -f ./SRA_DLs/$1_1.fastq -r ./SRA_DLs/$1_2.fastq  -1 ./SRA_DLs/$1.F.fq.gz -2 ./SRA_DLs/$1.R.fq.gz -s ./SRA_DLs/$1.M.fq.gz

### Map Reads and filter low quality mappings.
bowtie2 --very-sensitive -x $ref -U ./SRA_DLs/$1.M.fq | samtools view -q 30 -u - | samtools sort -o ./BAM_Files/$1.g.SE.sort.bam -
samtools rmdup -s ./BAM_Files/$1.g.SE.sort.bam ./BAM_Files/$1.g.SE.rmdup.bam

bowtie2 --very-sensitive -x $ref -1 ./SRA_DLs/$1.F.fq -2 ./SRA_DLs/$1.R.fq | samtools view -q 30 -u - | samtools sort -o ./BAM_Files/$1.g.PE.sort.bam
samtools rmdup ./BAM_Files/$1.g.PE.sort.bam ./BAM_Files/$1.g.PE.rmdup.bam

### Combine SE and PE reads into a single file
samtools merge ./BAM_Files/$1.g.merged.unsort.bam  ./BAM_Files/$1.g.SE.rmdup.bam ./BAM_Files/$1.g.PE.rmdup.bam
samtools sort -o ./BAM_Files/$1.g.final.bam ./BAM_Files/$1.g.merged.unsort.bam

### Index BAM File
samtools index ./BAM_Files/$1.g.final.bam
