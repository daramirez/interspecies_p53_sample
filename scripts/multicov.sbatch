#!/bin/bash 
#SBATCH --job-name=multicov
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=00:02:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load bedtools/2.28.0

bedtools multicov \
-s \
-bams \
/Shares/txpnevol/Nascent-Flow/Gorilla-gorGor6/mapped/bams/PRO-DMSO-Gorilla-2.sorted.bam \
/Shares/txpnevol/Nascent-Flow/Gorilla-gorGor6/mapped/bams/PRO-DMSO-Gorilla-3.sorted.bam \
/Shares/txpnevol/Nascent-Flow/Gorilla-gorGor6/mapped/bams/PRO-Nutlin-Gorilla-2.sorted.bam \
/Shares/txpnevol/Nascent-Flow/Gorilla-gorGor6/mapped/bams/PRO-Nutlin-Gorilla-3.sorted.bam \
-bed /Shares/txpnevol/daniel/manualRPKM/regions/gorGor6-p53upregulated.annot-shorterUTR.bed \
> /Shares/txpnevol/daniel/manualRPKM/multicov/gorGor6-p53upregulated.annot-shorterUTR.counts

echo Job finished at `date +"%T %a %d %b %Y"`
