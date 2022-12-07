#!/bin/bash
#SBATCH --job-name=meme
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=10gb
#SBATCH --time=10:00:00
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

meme \
-V \
-dna \
-p 8 \
-revcomp \
-mod anr \
-nmotifs 4 \
-objfun classic \
-bfile /Shares/txpnevol/genomes/hg38/hg38.main.background.txt \
-o /scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/meme/anr \
/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/tfea/temp_files/ranked_file.top500.1000bp.fa

#-minw 8 \
#-maxw 30 \

echo Job finished at `date +"%T %a %d %b %Y"`
