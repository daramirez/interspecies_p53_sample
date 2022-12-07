#!/bin/bash
#SBATCH --job-name=ATAC-bedGraphToBigWig
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20GB
#SBATCH --time=05:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run bamCoverage.sbatch on bam files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/mechanosensing/mapped sbatch --array 0-7 ATAC-bedGraphToBigWig.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

queries=($(ls ${dir}/bedgraphs/*hg38.scaled.bedgraph | xargs -n 1 basename | cut -d. -f1,2))

echo Input bam file: ${dir}/bedgraphs/${queries[$SLURM_ARRAY_TASK_ID]}.bam

/Users/dara6367/bin/UCSC_GenomeBrowser/bedGraphToBigWig \
${dir}/bedgraphs/${queries[$SLURM_ARRAY_TASK_ID]}.scaled.bedgraph \
/Shares/txpnevol/genomes/hg38/hg38.main.chrom.sizes \
${dir}/bigwigs/${queries[$SLURM_ARRAY_TASK_ID]}.bigwig

echo Job finished at `date +"%T %a %d %b %Y"`

