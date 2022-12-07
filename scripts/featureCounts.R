# This script calls the Rsubread featureCounts function to count PRO-seq reads mapping from Tfit bidirectional regions.
# It outputs an R object containing the counts for all the input bam files.

# Defines the input and output directories.
bamDir <- "/Shares/txpnevol/Nascent-Flow/Human/mapped/bams/"
countsDir <- "/Shares/txpnevol/Nascent-Flow/Human/DBE/featureCounts/"
annotFile <- "/Shares/txpnevol/Nascent-Flow/Human/DBE/annotations/PRO-Human.tfit.mumerge.saf"

# Defines the list of bam files on which to do the counting.
conditionsTable <- read.csv("/Shares/txpnevol/Nascent-Flow/Human/DBE/annotations/conditionsTable.csv")
fileList <- paste0(bamDir, conditionsTable$bamFileName)

# Calls featureCounts in R syntax.
library("Rsubread")
counts <- featureCounts(files=fileList,
			annot.ext=annotFile,
			isGTFAnnotationFile=FALSE,
			useMetaFeatures=TRUE,
			allowMultiOverlap=TRUE,
			largestOverlap=TRUE,
			isPairedEnd=FALSE,
			strandSpecific=0,
			nthreads=4)

# Saves the counts results, alongside other variables as an R image file.
save.image(paste0(countsDir, "PRO-Human.tfit.mumerge.featureCounts.RData"))

