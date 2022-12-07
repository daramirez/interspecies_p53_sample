#!/bin/bash
#SBATCH --job-name=ATAC-bamCoverage
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
#dir=/scratch/Users/dara6367/mechanosensing/mapped sbatch --array 0-5 ATAC-bamCoverage.sbatch

module load singularity

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img
queries=($(ls ${dir}/sambamba/*Bonobo*.bam | xargs -n 1 basename | cut -d. -f1,2))

echo Input bam file: ${dir}/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam

singularity exec --bind $dir $deeptools bamCoverage \
--bam ${dir}/sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
--outFileName ${dir}/bigwigs/${queries[$SLURM_ARRAY_TASK_ID]}.bigwig \
--outFileFormat bigwig \
--numberOfProcessors 8 \
--binSize 1 \
--normalizeUsing CPM

echo Job finished at `date +"%T %a %d %b %Y"`

