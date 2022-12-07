#!/bin/bash
#SBATCH --job-name=sambamba
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20GB
#SBATCH --time=01:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run sam-bam.sbatch on sam files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/mechanosensing/mapped sbatch --array 0-24 ATAC-sambamba.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

queries=($(ls ${dir}/bam/*.bam | xargs -n 1 basename | cut -d. -f1,2))

/Users/dara6367/miniconda2/bin/sambamba markdup \
--nthreads=8 --remove-duplicates --overflow-list-size=400000 \
${dir}/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
${dir}/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam

echo Job finished at `date +"%T %a %d %b %Y"`

