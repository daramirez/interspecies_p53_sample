#!/bin/bash
#SBATCH --job-name=fasta-get-markov
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH --time=00:30:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

### Display job context
echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
printf "Run on: $(hostname)\n"
printf "Submitted from: $(pwd)\n"
printf "Script: $0\n"
printf "\nYou've requested $SLURM_CPUS_ON_NODE core(s).\n\n"
echo Job started at `date +"%T %a %d %b %Y"`

module load meme/5.0.3

fasta-get-markov \
-m 0 \
-dna \
/scratch/Shares/dowell/DanielRamirez/forRu/referenceGenomes/Human-hs1/hs1.fa \
/scratch/Shares/dowell/DanielRamirez/forRu/referenceGenomes/Human-hs1/hs1.background.txt

echo Job finished at `date +"%T %a %d %b %Y"`

