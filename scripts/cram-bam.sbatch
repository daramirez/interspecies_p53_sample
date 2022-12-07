#!/bin/bash
#SBATCH --job-name=cram-bam
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=03:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#Usage example
#dir=/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/Nascent-Flow sbatch --array 0-5 cram-bam.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load samtools/1.8

queries=($(ls ${dir}/crams/*.cram | xargs -n 1 basename | cut -d. -f1))

echo Input file: ${dir}/crams/${queries[$SLURM_ARRAY_TASK_ID]}.cram

samtools view \
-b  -T \
/Shares/txpnevol/genomes/Susie3/Susie3.main.fa \
-o ${dir}/bams/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
${dir}/crams/${queries[$SLURM_ARRAY_TASK_ID]}.cram

samtools index \
${dir}/bams/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
${dir}/bams/${queries[$SLURM_ARRAY_TASK_ID]}.bam.bai

echo Job finished at `date +"%T %a %d %b %Y"`

