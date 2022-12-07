#!/bin/bash
#SBATCH --job-name=nomulti
#SBATCH --mail-type=ALL
#SBATCH --mail-user=%u@colorado.edu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=50GB
#SBATCH --time=06:00:00
#SBATCH --partition=short
#SBATCH --output=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.out
#SBATCH --error=/Shares/txpnevol/daniel/eofiles/%x.%A.%a.err

#dir=/scratch/Users/dara6367/PRO-seq_interspecies-nutlin sbatch --array 0-49 removeMultimappedBam.sbatch

echo Job: $SLURM_JOB_NAME with ID $SLURM_JOB_ID
echo Running on host `hostname`
echo Job started at `date +"%T %a %d %b %Y"`
echo Directory is `pwd`
echo Using $SLURM_NTASKS processors, across $SLURM_NNODES nodes, with $SLURM_JOB_CPUS_PER_NODE cpus per node

module purge

export PATH=~:$PATH
export PATH=~/.local/bin:$PATH

module load samtools/1.8

deeptools=/scratch/Shares/public/singularity/deeptools-3.0.1-py35_1.img
queries=($(ls ${dir}/multimapped_bam/*Chimp*.sorted.bam | xargs -n 1 basename | cut -d. -f1))

samtools view -@ 4 -h -b -q 5 ${dir}/multimapped_bam/${queries[$SLURM_ARRAY_TASK_ID]}.sorted.bam \
> ${dir}/nomultimapped_bam/${queries[$SLURM_ARRAY_TASK_ID]}.nomulti.bam

samtools index ${dir}/nomultimapped_bam/${queries[$SLURM_ARRAY_TASK_ID]}.nomulti.bam \
${dir}/nomultimapped_bam/${queries[$SLURM_ARRAY_TASK_ID]}.nomulti.bam.bai

# Creates bedgraph files per strand from bam files.
singularity exec --bind $dir $deeptools bamCoverage \
--bam ${dir}/nomultimapped_bam/${queries[$SLURM_ARRAY_TASK_ID]}.nomulti.bam \
--outFileName ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.fw.bpm.bg \
--outFileFormat bedgraph \
--numberOfProcessors 4 \
--filterRNAstrand forward \
--binSize 1

#singularity exec --bind $dir $deeptools bamCoverage \
--bam ${dir}/nomultimapped_bam/${queries[$SLURM_ARRAY_TASK_ID]}.nomulti.bam \
--outFileName ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.rv.bpm.bg \
--outFileFormat bedgraph \
--numberOfProcessors 4 \
--filterRNAstrand reverse \
--binSize 1

# Converts the coverage column on the reverse strand onto negative values.
awk -v OFS='\t' '{$4=-$4; print $0 }' \
${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.rv.bpm.bg \
> ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.rv.neg.bpm.bg

# Merges the two bigwig files with both strands onto the same bedgraph file.
cat ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.fw.bpm.bg \
${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.rv.neg.bpm.bg \
> ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tmp.bg

# Sorts the merged bedgraph file.
bedtools sort \
-i ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tmp.bg \
> ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.nomulti.bedGraph

# Removes intermediary files.
rm ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.bpm.tmp.bg
rm ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.rv.neg.bpm.bg
rm ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.fw.bpm.bg
rm ${dir}/nomultimapped_bedgraph/${queries[$SLURM_ARRAY_TASK_ID]}.rv.bpm.bg

echo Job finished at `date +"%T %a %d %b %Y"`
