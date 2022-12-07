#!/bin/bash
#SBATCH --job-name=hisat2-PE
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50GB
#SBATCH --time=01:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run hisat2-PE on fastq paired-end files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/mechanosensing sbatch --array 0-3 ATAC-hisat2-PE.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load hisat2/2.1.0

genome=hg38
genomeIndex=/Shares/txpnevol/genomes/hg38/hisat2/hg38.main

queriesR1=($(ls ${dir}/trimmed/*WTC11*_R1.fastq.gz | xargs -n 1 basename | cut -d_ -f1))
queriesR2=($(ls ${dir}/trimmed/*WTC11*_R2.fastq.gz | xargs -n 1 basename | cut -d_ -f1))

echo Input file R1: ${dir}/trimmed/${queriesR1[$SLURM_ARRAY_TASK_ID]}_R1.fastq.gz
echo Input file R2: ${dir}/trimmed/${queriesR2[$SLURM_ARRAY_TASK_ID]}_R2.fastq.gz

hisat2 \
--threads 8 \
--new-summary \
--very-sensitive \
--no-spliced-alignment \
-x ${genomeIndex} \
-1 ${dir}/trimmed/${queriesR1[$SLURM_ARRAY_TASK_ID]}_R1.fastq.gz \
-2 ${dir}/trimmed/${queriesR2[$SLURM_ARRAY_TASK_ID]}_R2.fastq.gz \
> ${dir}/mapped/sam/${queriesR1[$SLURM_ARRAY_TASK_ID]}.${genome}.sam \
2> ${dir}/qc/hisat2/${queriesR1[$SLURM_ARRAY_TASK_ID]}.${genome}.hisat2.txt

echo Job finished at `date +"%T %a %d %b %Y"`

