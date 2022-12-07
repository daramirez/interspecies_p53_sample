#!/bin/bash
#SBATCH --job-name=macs2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50GB
#SBATCH --time=10:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run sam-bam.sbatch on sam files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/mechanosensing sbatch --array 0-1 ATAC-macs2.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load python/2.7.14/MACS/2.1.1

queries=($(ls ${dir}/mapped/sambamba/*Nutlin*Bonobo*.bam | xargs -n 1 basename | cut -d. -f1,2))

echo Input bam file: ${dir}/mapped/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam

macs2 callpeak \
--treatment ${dir}/mapped/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
--name ${queries[$SLURM_ARRAY_TASK_ID]}.macs2 \
--outdir ${dir}/MACS2/ \
--nolambda --nomodel --keep-dup all --call-summits

head -23 ${dir}/MACS2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2_peaks.xls \
> ${dir}/qc/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2_peaks.xls 

echo Job finished at `date +"%T %a %d %b %Y"`

