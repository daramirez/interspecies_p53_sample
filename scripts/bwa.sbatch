#!/bin/bash
#SBATCH --job-name=bwa-index
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50GB
#SBATCH --time=12:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module purge

export PATH=~:$PATH
export PATH=~/.local/bin:$PATH

module load bwa/0.7.15

cd /Shares/txpnevol/genomes/hg38/bwa
bwa index /Shares/txpnevol/genomes/hg38/hg38.main.fa

echo Job finished at `date +"%T %a %d %b %Y"`

