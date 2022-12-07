#!/bin/bash
#SBATCH --job-name=bam-tdf
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB
#SBATCH --time=02:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load python/3.6.3
module load bedtools/2.28.0
module load samtools/1.8
module load gcc/7.1.0
module load igvtools/2.3.75
module load mpich/3.2.1

dir=/scratch/Users/dara6367/PRO-seq_interspecies-nutlin
chrom_sizes=/Shares/txpnevol/genomes/panTro6/panTro6.chrom.sizes
file_prefix=PRO-Nutlin-Chimp-3.panTro6

samtools view -@ 16 -F 0x904 \
-c ${dir}/PRO_bams_mmfilt/${file_prefix}.bam \
> ${dir}/tdfs_mmfilt/${file_prefix}.mp

genomeCoverageBed \
-bg \
-strand + \
-g ${chrom_sizes} \
-ibam ${dir}/PRO_bams_mmfilt/${file_prefix}.bam \
> ${dir}/tdfs_mmfilt/${file_prefix}.pos.bedGraph

genomeCoverageBed \
-bg \
-strand - \
-g ${chrom_sizes} \
-ibam ${dir}/PRO_bams_mmfilt/${file_prefix}.bam \
| awk 'BEGIN{FS=OFS="\t"} {$4=-$4}1' \
> ${dir}/tdfs_mmfilt/${file_prefix}.neg.bedGraph

cat ${dir}/tdfs_mmfilt/${file_prefix}.pos.bedGraph \
${dir}/tdfs_mmfilt/${file_prefix}.neg.bedGraph \
> ${dir}/tdfs_mmfilt/${file_prefix}.unsorted.bedGraph

sortBed \
-i ${dir}/tdfs_mmfilt/${file_prefix}.unsorted.bedGraph \
> ${dir}/tdfs_mmfilt/${file_prefix}.bedGraph

python /Shares/txpnevol/daniel/scripts/rcc.py \
${dir}/tdfs_mmfilt/${file_prefix}.bedGraph \
${dir}/tdfs_mmfilt/${file_prefix}.mp \
${dir}/tdfs_mmfilt/${file_prefix}.rcc.bedGraph

igvtools toTDF \
${dir}/tdfs_mmfilt/${file_prefix}.rcc.bedGraph \
${dir}/tdfs_mmfilt/${file_prefix}.rcc.tdf \
${chrom_sizes}

rm ${dir}/tdfs_mmfilt/${file_prefix}.pos.bedGraph
rm ${dir}/tdfs_mmfilt/${file_prefix}.neg.bedGraph
rm ${dir}/tdfs_mmfilt/${file_prefix}.unsorted.bedGraph
rm ${dir}/tdfs_mmfilt/${file_prefix}.bedGraph
rm ${dir}/tdfs_mmfilt/${file_prefix}.mp
rm ${dir}/tdfs_mmfilt/${file_prefix}.rcc.bedGraph

echo Job finished at `date +"%T %a %d %b %Y"`
