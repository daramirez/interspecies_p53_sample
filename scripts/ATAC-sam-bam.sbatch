#!/bin/bash
#SBATCH --job-name=sam-bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50GB
#SBATCH --time=02:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run sam-bam.sbatch on sam files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/mechanosensing sbatch --array 0-24 ATAC-sam-bam.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load samtools/1.8

queries=($(ls ${dir}/mapped/sam/*.sam | xargs -n 1 basename | cut -d. -f1,2))

#The option -F 4 filters out all unmapped reads.
samtools view \
-@ 8 -bS -F 4 \
${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.sam \
-o ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam

samtools sort \
-@ 8 \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
> ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam

samtools flagstat \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
> ${dir}/qc/samtools/${queries[$SLURM_ARRAY_TASK_ID]}.flagstat

samtools index \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam.bai

rm ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam
mv ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam

echo Job finished at `date +"%T %a %d %b %Y"`

