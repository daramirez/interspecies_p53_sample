#!/bin/bash
#SBATCH --job-name=nascentflow
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=8GB
#SBATCH --time=10:00:00
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
module load bedtools/2.28.0
module load samtools/1.8
module load gcc/7.1.0
module load sra/2.9.2
module load bbmap/38.05
module load igvtools/2.3.75
module load hisat2/2.1.0
module load fastqc/0.11.8
module load preseq/2.0.3
module load mpich/3.2.1
module load seqkit/0.9.0

/Users/dara6367/nextflow run \
/Users/dara6367/repos/Nascent-Flow/main.nf \
-profile slurm_Susie3 \
--workdir '/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/Nascent-Flow/temp' \
--genome_id 'Susie3' \
--outdir '/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/Nascent-Flow' \
--email dara6367@colorado.edu \
--fastqs '/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/otherAssemblies/fastq/PRO*.fastq.gz' \
--flip \
--singleEnd \
--unStranded \
--skipAllQC

echo Job finished at `date +"%T %a %d %b %Y"`
