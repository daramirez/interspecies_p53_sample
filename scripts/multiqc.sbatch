#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5GB
#SBATCH --time=00:10:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

module load singularity

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

multiqc=/scratch/Shares/public/singularity/multiqc-1.7.img

singularity exec --bind /scratch/Users/dara6367 ${multiqc} multiqc \
/scratch/Users/dara6367/IFNa2-cis-trans/forMultiQC \
-o /scratch/Users/dara6367/IFNa2-cis-trans/forMultiQC

echo Job finished at `date +"%T %a %d %b %Y"`
