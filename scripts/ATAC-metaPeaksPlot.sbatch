#!/bin/bash
#SBATCH --job-name=metaPeaksPlot
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50GB
#SBATCH --time=01:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%j.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%j.err

module load singularity
module load python/3.6.3

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

dir=/scratch/Users/dara6367/ATAC-seq_Nutlin-IFN
deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img

singularity exec --bind ${dir} ${deeptools} \
computeMatrix reference-point \
--regionsFileName ${dir}/deeptools/regions/TSS_conservation_groups.bed \
--referencePoint center \
--scoreFileName \
/scratch/Users/dara6367/ChIP-seq_public_LCL/mapped/bigwig/ChIP-GM12878-DMSO-p53.hg38.bigwig \
/scratch/Users/dara6367/ChIP-seq_public_LCL/mapped/bigwig/ChIP-GM12878-Doxorubicin-p53.hg38.bigwig \
--outFileName ${dir}/deeptools/computeMatrix/ChIP-DMSO-Nutlin-TSSconservationGroups.matrix.gz \
--upstream 1500 \
--downstream 1500 \
--numberOfProcessors 8 \
--binSize 10 \
--averageTypeBins "mean" \
--skipZeros \
--samplesLabel DMSO Doxo

singularity exec --bind ${dir} ${deeptools} \
plotHeatmap \
--matrixFile ${dir}/deeptools/computeMatrix/ChIP-DMSO-Nutlin-TSSconservationGroups.matrix.gz \
--outFileName ${dir}/deeptools/plotHeatmap/ChIP-DMSO-Nutlin-TSSconservationGroups.pdf \
--sortRegions "descend" \
--averageTypeSummaryPlot "mean" \
--colorList "white","black" \
--startLabel " " \
--endLabel " " \
--regionsLabel " " \
--xAxisLabel " " \
--refPointLabel " " \
--legendLocation "upper-center" \
--regionsLabel 1 2 3 4 5 6 6 8 9 10 \
--plotTitle "ATAC-seq coverage on genes TSS" \
--plotFileFormat "pdf" \
--perGroup

echo Job finished at `date +"%T %a %d %b %Y"`

