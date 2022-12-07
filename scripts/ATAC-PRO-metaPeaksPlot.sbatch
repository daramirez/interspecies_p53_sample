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

deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img

singularity exec --bind /scratch/Users/dara6367 ${deeptools} \
computeMatrix reference-point \
--regionsFileName /scratch/Users/dara6367/ATAC-seq_Nutlin-IFN/deeptools/regions/ROI.bed \
--referencePoint center \
--scoreFileName \
/scratch/Users/dara6367/ATAC-seq_Nutlin-IFN/mapped/bigwigs/ATAC-DMSO-Human-1.bbduk.hg38.sorted.dedup.cpm.bw \
/scratch/Users/dara6367/ATAC-seq_Nutlin-IFN/mapped/bigwigs/ATAC-Nutlin-Human-1.bbduk.hg38.sorted.dedup.cpm.bw \
/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Nascent-Flow/Human/mapped/bigwigs/PRO-DMSO-Human-1.bigwig \
/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Nascent-Flow/Human/mapped/bigwigs/PRO-Nutlin-Human-1.bigwig \
--outFileName /scratch/Users/dara6367/ATAC-seq_Nutlin-IFN/deeptools/computeMatrix/ATAC-DMSO_ATAC-Nutlin_PRO-DMSO_PRO-Nutlin.matrix.gz \
--upstream 1500 \
--downstream 1500 \
--numberOfProcessors 8 \
--binSize 10 \
--averageTypeBins "mean" \
--skipZeros \
--samplesLabel ATAC-DMSO ATAC-Nutlin PRO-DMSO PRO-Nutlin

singularity exec --bind /scratch/Users/dara6367 ${deeptools} \
plotHeatmap \
--matrixFile /scratch/Users/dara6367/ATAC-seq_Nutlin-IFN/deeptools/computeMatrix/ATAC-DMSO_ATAC-Nutlin_PRO-DMSO_PRO-Nutlin.matrix.gz \
--outFileName /scratch/Users/dara6367/ATAC-seq_Nutlin-IFN/deeptools/plotHeatmap/ATAC-DMSO_ATAC-Nutlin_PRO-DMSO_PRO-Nutlin.pdf \
--sortRegions "keep" \
--averageTypeSummaryPlot "mean" \
--colorList "#330066","#33ff99","#ffff1a" \
--startLabel " " \
--endLabel " " \
--regionsLabel " " \
--xAxisLabel " " \
--refPointLabel " " \
--legendLocation "upper-center" \
--regionsLabel topBidirs PROtopTSS \
--plotTitle "ATAC-PRO-seq coverage on ROI" \
--plotFileFormat "pdf" \
--perGroup

#--heatmapHeight 25 \
#--heatmapWidth 20 \

echo Job finished at `date +"%T %a %d %b %Y"`

