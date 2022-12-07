#!/bin/bash 
#SBATCH --job-name=fastQC
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4GB
#SBATCH --time=01:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run fastQC on all fastq files as separate sbatch jobs:
# sbatch --array 0-15 RNA-fastqc.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load fastqc/0.11.5

dir=/scratch/Users/dara6367/old_sequencing_testing
queries=($(ls ${dir}/fastq/*.fastq.gz | xargs -n 1 basename))

echo Input file: ${dir}/fastq/${queries[$SLURM_ARRAY_TASK_ID]}

fastqc \
--format fastq \
--threads 1 \
${dir}/fastq/${queries[$SLURM_ARRAY_TASK_ID]} \
--outdir ${dir}/qc/fastqc/

echo Job finished at `date +"%T %a %d %b %Y"`
