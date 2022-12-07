#!/bin/bash
#SBATCH --job-name=fastqdump
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=10gb
#SBATCH --time=23:59:00
#SBATCH --partition=short
#SBATCH --output=/scratch/Users/dara6367/ChIP-seq_public_LCL/fastq/eofiles/%x.%j.out
#SBATCH --error=/scratch/Users/dara6367/ChIP-seq_public_LCL/fastq/eofiles/%x.%j.err

#To run all SRA downloads at once, run the following loop from the command line.
#for i in `cat /scratch/Users/dara6367/ChIP-seq_public_LCL/fastq/SraAccList.txt`
#do sbatch --export=SRA=$i fastqdumpSRA.sbatch
#done

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

/opt/sra/2.10.5/bin/prefetch-orig.2.10.5 \
--max-size 100G \
--output-directory /scratch/Users/dara6367/ChIP-seq_public_LCL/fastq \
${SRA}

/opt/sra/2.8.0/bin/fastq-dump.2.8.0 \
--split-3 \
--gzip \
--outdir /scratch/Users/dara6367/ChIP-seq_public_LCL/fastq \
/scratch/Users/dara6367/ChIP-seq_public_LCL/fastq/${SRA}/${SRA}.sra

echo Job finished at `date +"%T %a %d %b %Y"`
