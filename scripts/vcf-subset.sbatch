#!/bin/bash
#SBATCH --job-name=vcf-subset
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=23:00:00
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

module load samtools/1.10

dir=/Shares/txpnevol/intrahuman-IFNB/vcf

cd /Users/dara6367/repos/vcftools/src/perl

tabix -h ${dir}/ALL.chrX.shapeit2_integrated_snvindels_v2a_27022019.GRCh38.phased.vcf.gz \
X:1-156040895 | \
perl ./vcf-subset -c NA12878,HG03077,NA19024,NA18489,HG02150,HG03645,NA18530 \
> ${dir}/Seven.chrX.vcf

echo Job finished at `date +"%T %a %d %b %Y"`
