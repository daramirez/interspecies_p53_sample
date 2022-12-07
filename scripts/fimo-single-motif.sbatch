#!/bin/bash
#SBATCH --job-name=fimo
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50GB
#SBATCH --time=00:10:00
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

module load meme/5.1.1

fimo \
-max-stored-scores 10000000 \
--thresh 1e-6 \
--text \
--max-strand \
--skip-matched-sequence \
--bgfile /Shares/txpnevol/genomes/hg38/hg38.main.background.txt \
--motif TP53_M06704_1 \
/Users/dara6367/repos/TFEA/motif_files/best_curated_Human.meme \
/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/fimo/RNA-Human-TSS.fa \
> /scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/fimo/RNA-Human-TSS_TP53_M06704_1.1e-6.txt

echo Job finished at `date +"%T %a %d %b %Y"`
