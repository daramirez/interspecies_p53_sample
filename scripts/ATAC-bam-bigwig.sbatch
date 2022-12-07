#!/bin/bash
#SBATCH --job-name=ATAC-bam-bigwig
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20GB
#SBATCH --time=03:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

#Usage
#dir=/scratch/Users/dara6367/A549-IFN-B/mapped sbatch --array 0-2 ATAC-bam-bigwig.sbatch

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
queries=($(ls ${dir}/ATAC_sambamba/*bam | xargs -n 1 basename | cut -d'.' -f1,2))

singularity exec --bind /scratch/Users/dara6367 \
${deeptools} bamCoverage \
--bam ${dir}/ATAC_sambamba/${queries[$SLURM_ARRAY_TASK_ID]}.bam \
--outFileFormat bigwig \
--outFileName ${dir}/ATAC_bigwigs/${queries[$SLURM_ARRAY_TASK_ID]}.bigwig \
--binSize 1 \
--scaleFactor 1 \
--numberOfProcessors 8 \
--normalizeUsing RPKM

echo Job finished at `date +"%T %a %d %b %Y"`
