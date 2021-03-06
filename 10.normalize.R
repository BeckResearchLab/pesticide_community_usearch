#!/usr/bin/env Rscript

library(docopt)

"Usage: 12.normalize.R [-h] <infilename> <samplefilename> <outfilename>

-h --help        show this message
infilename       name of OTU input file
samplefilename   name of sample info input file
outfilename      name of the normalized output file" -> doc
args <- docopt(doc)

library(DESeq2)

d <- read.delim(args$infilename, header=T, row.names=1)
head(d)

e <- d[, -which(names(d) %in% c("domain", "domain_confidence", "phylum", "phylum_confidence", "class", "class_confidence", "order_", "order_confidence", "family", "family_confidence", "genus", "genus_confidence", "species", "species_confidence", "sequence"))]
head(e)

eexp <- read.delim(args$samplefilename, header=T, row.names=1)
head(d)
#eexp <- data.frame(row.names=colnames(e), sample=colnames(e), condition=colnames(e))
dds <- DESeqDataSetFromMatrix(countData=e, colData=eexp, design=~condition)

ddrs <- DESeq(dds)

rld <- rlogTransformation(ddrs, blind=TRUE)
vsd <- varianceStabilizingTransformation(ddrs, blind=TRUE)

normCounts <- assay(rld)

normD <- cbind(normCounts, d[, which(names(d) %in% c("domain", "domain_confidence", "phylum", "phylum_confidence", "class", "class_confidence", "order_", "order_confidence", "family", "family_confidence", "genus", "genus_confidence", "species", "species_confidence", "sequence"))])

write.table(format(normD, digits=2), file=args$outfilename, quote=FALSE, sep='\t', col.names=NA)
