#!/bin/bash
#SBATCH --job-name=sam-bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=50GB
#SBATCH --time=02:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run sam-bam on fastq single-end files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/RNA-seq_species-nutlin sbatch --array 0-5 RNA-sam-bam.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load samtools/1.8

queries=($(ls ${dir}/mapped/sam/*.sam | xargs -n 1 basename | cut -d. -f1,2))

echo Input file: ${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.sam

samtools view \
-@ 4 -bS \
${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.sam \
-o ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam

samtools sort \
-@ 4 \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
> ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam

samtools flagstat \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
> ${dir}/qc/${queries[$SLURM_ARRAY_TASK_ID]}.bam.flagstat

samtools index \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam.bai

echo Job finished at `date +"%T %a %d %b %Y"`
