#!/bin/bash
#SBATCH --job-name=rseqc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
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

module load python/3.6.3
module load gcc/7.1.0
module load mpich/3.2.1

dir=/scratch/Users/dara6367/IFNa2-cis-trans
sample=PRO-BSA-Human-F
annotation=/Shares/txpnevol/genomes/hg38/annotation/hg38.refseq.annotation.bed

read_distribution.py \
-i ${dir}/mapped/bams/${sample}.bam \
-r ${annotation} \
> ${dir}/rseqc/${sample}.read_dist.txt

read_duplication.py \
-i ${dir}/mapped/bams/${sample}.bam \
-o ${dir}/rseqc/${sample}.read_duplication

infer_experiment.py \
-i ${dir}/mapped/bams/${sample}.bam \
-r ${annotation} \
> ${dir}/rseqc/${sample}.infer_experiment.txt

echo Job finished at `date +"%T %a %d %b %Y"`
