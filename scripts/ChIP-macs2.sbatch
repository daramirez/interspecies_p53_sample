#!/bin/bash
#SBATCH --job-name=macs2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20GB
#SBATCH --time=02:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#To run macs2.sbatch on sam files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/ChIP-seq_public_LCL sbatch --array 0-16 ChIP-macs2.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module load python/2.7.14/MACS/2.1.1

queries=($(ls ${dir}/mapped/bam/*sorted.bam | xargs -n 1 basename | cut -d. -f1,2))

echo Input bam file: ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam

# Runs MACS2.
macs2 callpeak \
--treatment ${dir}/mapped/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
--name ${queries[$SLURM_ARRAY_TASK_ID]}.macs2 \
--outdir ${dir}/macs2/ \
--nolambda --nomodel --keep-dup all --call-summits

# Stores header of .xls output into the quality control directory.
head -23 ${dir}/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2_peaks.xls \
> ${dir}/qc/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2 

# Keeps peaks with a score greater than 300
# Sorts the peaks in descending order based on their score.
# Removes peaks with a width shorter than 1000, and a width greater than 5000.
# Changes the peaks so that they have a width of 3000, centered at the middle of the original peak.
awk -v OFS='\t' '{if ($5 > 300) print $0}' ${dir}/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2_peaks.narrowPeak | \
sort -k 5,5 | \
cut -f1,2,3 | \
awk -v OFS='\t' '{if ($3-$2 > 1000) print $0}' | \
awk -v OFS='\t' '{if ($3-$2 < 5000) print $0}' | \
awk -v OFS='\t' '{print $1, sprintf("%.0f",($2+(($3-$2)/2))-1500) , sprintf("%.0f",($2+(($3-$2)/2))+1500) }' \
> ${dir}/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.filt.macs2.bed

# Removes extra macs2 output files.
rm ${dir}/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2_summits.bed
rm ${dir}/macs2/${queries[$SLURM_ARRAY_TASK_ID]}.macs2_peaks.xls

echo Job finished at `date +"%T %a %d %b %Y"`

