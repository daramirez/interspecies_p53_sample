#!/bin/bash
#SBATCH --job-name=Bidirectional-Flow
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=8GB
#SBATCH --time=99:59:00
#SBATCH --partition=long
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
module load bedtools/2.28.0
module load samtools/1.10
module load gcc/7.1.0
module load openmpi/1.6.4

/scratch/Shares/dowell/dbnascent/pipeline_assets/nextflow run \
/Users/dara6367/repos/Bidirectional-Flow/main.nf \
-profile Susie3_dara6367 \
--outdir '/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/Bidirectional-Flow' \
--bams '/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/Nascent-Flow/bams/*.bam' \
--workdir '/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/Bidirectional-Flow/temp' \
--singleEnd \
--tfit

echo Job finished at `date +"%T %a %d %b %Y"`

