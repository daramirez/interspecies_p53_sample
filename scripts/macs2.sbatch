#!/bin/bash
#SBATCH --job-name=macs2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50GB
#SBATCH --time=02:00:00
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

module load python/2.7.14/MACS/2.1.1

dir=/Shares/txpnevol/ChIP-p53-GM12878

macs2 callpeak \
--treatment ${dir}/ChIP-Flow/mapped/bams/ChIP-Nutlin-GM12878-p53.sorted.bam \
--control ${dir}/ChIP-Flow/mapped/bams/ChIP-Nutlin-GM12878-input.sorted.bam \
--format BAM \
--gsize hs \
--bdg \
--name Nutlin-GM12878 \
--outdir ${dir}/MACS2

echo Job finished at `date +"%T %a %d %b %Y"`
