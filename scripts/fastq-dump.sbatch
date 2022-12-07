#!/bin/bash
#SBATCH --job-name=download
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50GB
#SBATCH --time=23:59:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

#To run all SRA downloads at once, run the following loop from the command line.
#for i in `cat /scratch/Users/dara6367/ChIP-seq_public_LCL/fastq/SraAccList.txt`
#do sbatch --export=SRA=$i fastq-dump.sbatch
#done

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module purge

export PATH=~:$PATH
export PATH=~/.local/bin:$PATH

module load sra/2.9.2

fastq-dump \
--outdir /scratch/Users/dara6367/ChIP-seq_public_LCL/fastq/ \
--split-files \
--accession SRR7647731

#prefetch -v ${SRA}

echo Job finished at `date +"%T %a %d %b %Y"`

