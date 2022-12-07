#!/bin/bash
#SBATCH --job-name=split_bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=25GB
#SBATCH --time=03:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run rseqc split_bam on distinct bam files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/mechanosensing sbatch --array 0-4 split_bam.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load python/2.7.14/rseqc

queries=($(ls ${dir}/mapped/sambamba/*scVIC*bam | xargs -n 1 basename | cut -d. -f1,2))

echo Input bam file: ${dir}/mapped/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam

split_bam.py \
--input-file ${dir}/mapped/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
--genelist ${dir}/mumerge/scVIC.susScr11-macs2_MUMERGE.12.bed \
--out-prefix ${dir}/FRIP/split_bam/${queries[$SLURM_ARRAY_TASK_ID]}

echo Job finished at `date +"%T %a %d %b %Y"`
