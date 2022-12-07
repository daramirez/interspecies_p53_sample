#!/bin/bash
#SBATCH --job-name=trimming
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20GB
#SBATCH --time=01:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#dir=/scratch/Users/dara6367/mechanosensing sbatch --array 0-24 RNA-trimming.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load bbmap/38.05

# Single-end reads

#queries=($(ls ${dir}/fastq/*.fastq.gz | xargs -n 1 basename | cut -d. -f1))

#bbduk.sh \
#-Xmx20g \
#t=4 \
#in=${dir}/fastq/${queries[$SLURM_ARRAY_TASK_ID]}.fastq.gz \
#out=${dir}/trimmed/${queries[$SLURM_ARRAY_TASK_ID]}.fastq.gz \
#ref=/Users/dara6367/repos/Nascent-Flow/bin/adapters.fa \
#ktrim=r \
#qtrim=10 \
#k=23 \
#mink=11 \
#hdist=1 \
#maq=10 \
#minlen=25 \
#tpe \
#tbo \
#literal=AAAAAAAAAAAAAAAAAAAAAAA \
#stats=${dir}/qc/bbduk/${queries[$SLURM_ARRAY_TASK_ID]}.trimstats.txt \
#refstats=${dir}/qc/bbduk/${queries[$SLURM_ARRAY_TASK_ID]}.refstats.txt \
#ehist=${dir}/qc/bbduk/${queries[$SLURM_ARRAY_TASK_ID]}.ehist.txt

# Paired-end reads

queriesR1=($(ls ${dir}/fastq/*_R1.fastq.gz | xargs -n 1 basename | cut -d_ -f1))
queriesR2=($(ls ${dir}/fastq/*_R2.fastq.gz | xargs -n 1 basename | cut -d_ -f1))

bbduk.sh \
-Xmx20g \
t=4 \
in1=${dir}/fastq/${queriesR1[$SLURM_ARRAY_TASK_ID]}_R1.fastq.gz \
in2=${dir}/fastq/${queriesR2[$SLURM_ARRAY_TASK_ID]}_R2.fastq.gz \
out1=${dir}/trimmed/${queriesR1[$SLURM_ARRAY_TASK_ID]}_R1.fastq.gz \
out2=${dir}/trimmed/${queriesR2[$SLURM_ARRAY_TASK_ID]}_R2.fastq.gz \
ref=/Users/dara6367/repos/Nascent-Flow/bin/adapters.fa \
ktrim=r \
qtrim=10 \
k=23 \
mink=11 \
hdist=1 \
maq=10 \
minlen=25 \
tpe \
tbo \
literal=AAAAAAAAAAAAAAAAAAAAAAA \
stats=${dir}/qc/bbduk/${queriesR1[$SLURM_ARRAY_TASK_ID]}.trimstats.txt \
refstats=${dir}/qc/bbduk/${queriesR1[$SLURM_ARRAY_TASK_ID]}.refstats.txt \
ehist=${dir}/qc/bbduk/${queriesR1[$SLURM_ARRAY_TASK_ID]}.ehist.txt

echo Job finished at `date +"%T %a %d %b %Y"`
