#!/bin/bash
#SBATCH --job-name=hisat2-PE
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=50GB
#SBATCH --time=03:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#dir=/scratch/Users/dara6367/inter_intra_IFN sbatch --array 0-65 RNA-hisat2-PE.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load hisat2/2.1.0
module load samtools/1.8

genomeIndex=/Shares/txpnevol/genomes/hs1/hisat2/hs1
genomePrefix=hs1
queries=($(ls ${dir}/trimmed/*_R1.fastq.gz | xargs -n 1 basename | cut -d_ -f1))

echo Input file R1: ${dir}/trimmed/${queries[$SLURM_ARRAY_TASK_ID]}_R1.fastq.gz
echo Input file R2: ${dir}/trimmed/${queries[$SLURM_ARRAY_TASK_ID]}_R2.fastq.gz

hisat2 \
--threads 4 \
--new-summary \
--very-sensitive \
--summary-file ${dir}/qc/hisat2/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.hisat2.txt \
-x ${genomeIndex} \
-1 ${dir}/trimmed/${queries[$SLURM_ARRAY_TASK_ID]}_R1.fastq.gz \
-2 ${dir}/trimmed/${queries[$SLURM_ARRAY_TASK_ID]}_R2.fastq.gz \
> ${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sam

samtools view \
-@ 4 -bS \
${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sam \
-o ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam

samtools sort \
-@ 4 \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam \
> ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam

samtools flagstat \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam \
> ${dir}/qc/samtools/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam.flagstat

samtools index \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam.bai

rm ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam
rm ${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sam
mv ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam

echo Job finished at `date +"%T %a %d %b %Y"`
