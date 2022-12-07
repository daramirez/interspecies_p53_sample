#!/bin/bash
#SBATCH --job-name=bam-tdf
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=50GB
#SBATCH --time=06:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#dir=/scratch/Users/dara6367/ChIP-seq_public_LCL/mapped sbatch --array 0-16 ChIP-bam-tdf.sbatch

module load singularity
module load bedtools/2.25.0
module load igvtools/2.3.75

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img
queries=($(ls ${dir}/bam/*.sorted.bam | xargs -n 1 basename | cut -d. -f1,2))

echo Input bam file: ${dir}/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam

# Convert bam to bedgraph.
singularity exec --bind $dir $deeptools bamCoverage \
--bam ${dir}/bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
--outFileName ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tmp.bg \
--outFileFormat bedgraph \
--numberOfProcessors 4 \
--binSize 1 \
--normalizeUsing BPM

# Sort the merged bedgraph file.
bedtools sort \
-i ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tmp.bg \
> ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.bg

# Modify bedgraph file to look like a wiggle file.
awk -v OFS=' ' '{print $1, $2, $3, $4}' \
${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.bg \
> ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.wig

# Create tdf file from sorted bedgraph file.
igvtools toTDF \
${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.wig \
${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tdf \
/Shares/txpnevol/genomes/hg38/hg38.main.fa

# Remove intermediary files.
rm ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tmp.bg
rm ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.bg
rm ${dir}/tdf/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.wig

echo Job finished at `date +"%T %a %d %b %Y"`

