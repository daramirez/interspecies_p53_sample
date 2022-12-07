#!/bin/bash
#SBATCH --job-name=computeMatrix
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100GB
#SBATCH --time=06:00:00
#SBATCH --partition=short
#SBATCH --output=/scratch/Users/dara6367/ATAC-seq_pig-hydrogels/eofiles/%x.%A.%a.out
#SBATCH --error=/scratch/Users/dara6367/ATAC-seq_pig-hydrogels/eofiles/%x.%A.%a.err

#To run computeMatrix on distinct bigwig files as separate sbatch jobs:
#dir=/scratch/Users/dara6367/ATAC-seq_pig-hydrogels sbatch --array 0-15 computeMatrix.sbatch

module load singularity
module load python/3.6.3

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img
queries=($(ls ${dir}/mapped/bigwig/*.susScr11.bw | xargs -n 1 basename | cut -d. -f1,2))

singularity exec --bind ${dir} ${deeptools} computeMatrix reference-point \
--regionsFileName ${dir}/misc/susScr11.ensGene.tss.bed \
--scoreFileName ${dir}/mapped/bigwig/${queries[$SLURM_ARRAY_TASK_ID]}.bw \
--outFileName ${dir}/TSSenrichment/computeMatrix/${queries[$SLURM_ARRAY_TASK_ID]}.matrix.gz \
--outFileNameMatrix ${dir}/TSSenrichment/computeMatrix/${queries[$SLURM_ARRAY_TASK_ID]}.matrix \
--upstream 2000 \
--downstream 2000 \
--numberOfProcessors 8 \
--binSize 1

echo Job finished at `date +"%T %a %d %b %Y"`

