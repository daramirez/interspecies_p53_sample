#!/bin/bash
#SBATCH --job-name=featureCounts
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20gb
#SBATCH --time=00:10:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

### This scripts runs the R script 'featureCounts.R'.
### It outputs an .RData file containing the counts generated for all the input PRO-seq samples.

### Display job context
echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
printf "Run on: $(hostname)\n"
printf "Submitted from: $(pwd)\n"
printf "Script: $0\n"
printf "\nYou've requested $SLURM_CPUS_ON_NODE core(s).\n\n"
echo Job started at `date +"%T %a %d %b %Y"`

module load R/3.5.1

RSCRIPT=/Shares/txpnevol/daniel/scripts/featureCounts.R
export R_LIBS='Users/dara6367/R/x86_64-pc-linux-gnu-library/3.5/'

# Run R script with the path to the annotation file.
Rscript ${RSCRIPT}

echo Job finished at `date +"%T %a %d %b %Y"`

