#!/bin/bash
#SBATCH --job-name=streme
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

/Users/dara6367/meme/bin/streme \
--verbosity 3 \
--dna \
--nmotifs 10 \
--objfun cd \
--minw 10 \
--maxw 20 \
--bfile /Shares/txpnevol/genomes/hg38/hg38.main.background.txt \
--o /scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/streme/cd \
--p /scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/tfea/temp_files/ranked_file.top500.1000bp.fa

echo Job finished at `date +"%T %a %d %b %Y"`
