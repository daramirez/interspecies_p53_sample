# This script calls the Rsubread featureCounts function to count PRO-seq reads.
# It outputs an R object containing the counts for all the input bam files.

# Defines the input and output directories.
bamDir <- "/scratch/Users/dara6367/inter_p53/mapped/PRO_bams_mmfilt/"
countsDir <- "/scratch/Users/dara6367/inter_p53/featureCounts/"
annotFile <- "/Shares/txpnevol/genomes/bosTau9/annotation/bosTau9.ncbiRefSeq.without5prime25.oneEntry.saf"

# Defines the list of bam files on which to do the counting.
conditionsTable <- read.csv("/scratch/Users/dara6367/inter_p53/featureCounts/conditionsTable.PRO-Nutlin-Cow.csv")
fileList <- paste0(bamDir, conditionsTable$bamFileName)

# Calls featureCounts in R syntax.

library("Rsubread")

# Using GTF
#counts <- featureCounts(files=fileList,
#                        annot.ext=annotFile,
#                        isGTFAnnotationFile=TRUE,
#                        useMetaFeatures=TRUE,
#                        GTF.featureType="exon",
#                        GTF.attrType="gene_id",
#                        allowMultiOverlap=TRUE,
#                        largestOverlap=TRUE,
#                        isPairedEnd=TRUE,
#                        strandSpecific=2,
#                        nthreads=8)

# Using SAF
counts <- featureCounts(files=fileList,
                        annot.ext=annotFile,
                        isGTFAnnotationFile=FALSE,
                        useMetaFeatures=TRUE,
                        allowMultiOverlap=TRUE,
                        largestOverlap=TRUE,
                        isPairedEnd=FALSE,
                        strandSpecific=1,
                        nthreads=8)

# Saves the counts results, alongside other variables as an R image file.
save.image(paste0(countsDir, "PRO-Nutlin-Cow.ncbiRefSeq.without5prime25.featureCounts.RData"))
