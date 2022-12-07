# This script calls the Rsubread featureCounts function to count PRO-seq reads.
# It outputs an R object containing the counts for all the input bam files.

# Defines the input and output directories.
bamDir <- "/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/bams/"
countsDir <- "/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/featureCounts/"
annotFile <- "/scratch/Users/dara6367/PRO-seq_interspecies-nutlin/Bidirectional-Flow/Human/mumerge/HCT116-tfit_MUMERGE.saf"

# Defines the list of bam files on which to do the counting.
conditionsTable <- read.csv(paste0(countsDir, "conditionsTable.PRO-Nutlin-HCT116.csv"))
fileList <- paste0(bamDir, conditionsTable$bamFileName)

# Calls featureCounts in R syntax.
library("Rsubread")

# Using SAF
counts <- featureCounts(files=fileList,
                        annot.ext=annotFile,
                        isGTFAnnotationFile=FALSE,
                        useMetaFeatures=TRUE,
                        allowMultiOverlap=TRUE,
                        largestOverlap=TRUE,
                        isPairedEnd=FALSE,
                        strandSpecific=0,
                        nthreads=8)

# Saves the counts results, alongside other variables as an R image file.
save.image(paste0(countsDir, "PRO-HCT116.tfit.featureCounts.RData"))

