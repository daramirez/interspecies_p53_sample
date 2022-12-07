#!/bin/bash
#SBATCH --job-name=mapping
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50GB
#SBATCH --time=06:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#dir=/scratch/Users/dara6367/ChIP-seq_public_LCL sbatch --array 0-4 ChIP-hisat2-SE.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load hisat2/2.1.0
module load samtools/1.8

genomeIndex=/Shares/txpnevol/genomes/hg38/hisat2/hg38.main
genomePrefix=hg38
queries=($(ls ${dir}/fastq/*gz | xargs -n 1 basename | cut -d. -f1))

echo Input file: ${dir}/fastq/${queries[$SLURM_ARRAY_TASK_ID]}.fastq.gz

hisat2 \
--threads 8 \
--new-summary \
--very-sensitive \
--summary-file ${dir}/qc/hisat2/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.hisat2.txt \
-x ${genomeIndex} \
-U ${dir}/fastq/${queries[$SLURM_ARRAY_TASK_ID]}.fastq.gz \
> ${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sam

#The option -F 4 filters out all unmapped reads.
samtools view \
-@ 8 -bS -F 4 \
${dir}/mapped/sam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sam \
-o ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam

samtools sort \
-@ 8 \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam \
> ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam

samtools index \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam \
${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.sorted.bam.bai

rm ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.${genomePrefix}.bam

echo Job finished at `date +"%T %a %d %b %Y"`

