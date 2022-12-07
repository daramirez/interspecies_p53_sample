# This script calls the Rsubread featureCounts function to count RNA-seq reads.
# It outputs an R object containing the counts for all the input bam files.

# Defines the input and output directories.
bamDir <- "/scratch/Users/dara6367/RNA-seq_species-nutlin/mapped/bam/"
countsDir <- "/scratch/Users/dara6367/RNA-seq_species-nutlin/featureCounts/"
annotFile <- "/Shares/txpnevol/genomes/hg38/annotation/hg38.ncbiRefSeq.gtf"

# Defines the list of bam files on which to do the counting.
conditionsTable <- read.csv("/scratch/Users/dara6367/RNA-seq_species-nutlin/misc/conditionsTable.RNA-Nutlin-Human.csv")
fileList <- paste0(bamDir, conditionsTable$bamFileName)

# Calls featureCounts in R syntax.
library("Rsubread")
countsRNA <- featureCounts(files=fileList,
			annot.ext=annotFile,
			isGTFAnnotationFile=TRUE,
			useMetaFeatures=TRUE,
			GTF.featureType="exon",
			GTF.attrType="gene_id",
			allowMultiOverlap=TRUE,
			largestOverlap=TRUE,
			isPairedEnd=FALSE,
			strandSpecific=2,
			nthreads=8)

# Saves the counts results, alongside other variables as an R image file.
save.image(paste0(countsDir, "RNA-Nutlin-Human.featureCounts.RData"))
