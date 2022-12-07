#!/bin/bash
#SBATCH --job-name=PRO-bam-bigwig
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50GB
#SBATCH --time=06:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

#Usage
#dir=/scratch/Users/dara6367/inter_p53/mapped sbatch --array 0-71 PRO-bam-bigwig.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module purge

export PATH=~:$PATH
export PATH=~/.local/bin:$PATH

module load bedtools/2.25.0 
module load singularity/3.1.1

deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img
queries=($(ls ${dir}/RNA_bams/*.bam | xargs -n 1 basename | cut -d'.' -f1,2))

singularity exec --bind /scratch/Users/dara6367 \
${deeptools} bamCoverage \
--bam ${dir}/RNA_bams/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
--outFileFormat bigwig \
--outFileName ${dir}/RNA_bigwigs/${queries[$SLURM_ARRAY_TASK_ID]}.pos.bigwig \
--filterRNAstrand forward \
--binSize 1 \
--scaleFactor 1 \
--numberOfProcessors 8 \
--normalizeUsing RPKM

singularity exec --bind /scratch/Users/dara6367 \
${deeptools} bamCoverage \
--bam ${dir}/RNA_bams/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
--outFileFormat bigwig \
--outFileName ${dir}/RNA_bigwigs/${queries[$SLURM_ARRAY_TASK_ID]}.neg.bigwig \
--filterRNAstrand reverse \
--binSize 1 \
--scaleFactor -1 \
--numberOfProcessors 8 \
--normalizeUsing RPKM

echo Job finished at `date +"%T %a %d %b %Y"`
