library(vegan)

# read the sample metadata
md <- read.table("sample_info.xls", header=T, sep='\t', row.names=1, comment.char="")
dim(md)
head(md)

# read the normalized read_sums
sample_read_sums <- read.table("10.normalize.read_sums.xls", header=T, sep="\t", row.names=1)
sample_read_sums
dim(sample_read_sums)

# read the persistent taxa list
best.tax <- read.table("11.best_tax.xls", header=T, sep='\t', row.names=1)
best.tax$desc <- sprintf("%s : %s (%s, %.2g)", rownames(best.tax), best.tax$best_tax, best.tax$best_tax_level, best.tax$best_tax_confidence)

# read in the raw data
raw_otus <- read.table("pesticide_community.xls", header=T, sep='\t', row.names=1)
raw_otus <- raw_otus[, -which(names(raw_otus) %in% c("domain", "domain_confidence", "phylum", "phylum_confidence", "class", "class_confidence", "order_", "order_confidence", "family", "family_confidence", "genus", "genus_confidence", "species", "species_confidence", "sequence"))]
head(raw_otus)
dim(raw_otus)

# create the fractional abundance data
otus_pcnt <- scale(raw_otus, center=FALSE, scale=t(sample_read_sums))
head(otus_pcnt)
otus_pcnt <- otus_pcnt[apply(otus_pcnt[,-1], 1, function(x) !all(x==0)),]
dim(otus_pcnt)

# read the log normalized data
log_otus <- read.table("pesticide_community.log_normalized.xls", header=T, sep='\t', row.names=1)
log_otus <- log_otus[, -which(names(log_otus) %in% c("domain", "domain_confidence", "phylum", "phylum_confidence", "class", "class_confidence", "order_", "order_confidence", "family", "family_confidence", "genus", "genus_confidence", "species", "species_confidence", "sequence"))]
head(log_otus)

# extract out the persistent OTUs
log_otus <- log_otus[row.names(best.tax),]
otus_pcnt <- otus_pcnt[row.names(best.tax),]
dim(log_otus)

# make the full sample dataframe
sample_full <- data.frame(t(log_otus), pesticide = md$pesticide, day = md$day, concentration = md$concentration)
dim(sample_full)
sample_full

dim(t(log_otus))

# data preparation done

#################################################################
# MDS

mds <- metaMDS(t(log_otus), maxit=10000, trymax=1000)
mds

mds$points
x=mds$points[sample_full$pesticide == 'control', 1]
y=mds$points[sample_full$pesticide == 'control', 2]

pdf("13.MDS.pdf")#, width=5, height=5)

plot(mds$points, type = "n")
points(x, y, cex = 2.0, pch=21, col="black", bg="black")
points(mds$points[sample_full$pesticide == 'chlorpyrifos' & sample_full$concentration == 'x4', ], cex = 2.0, pch=24, col="black", bg="magenta")
points(mds$points[sample_full$pesticide == 'chlorpyrifos' & sample_full$concentration == 'x1', ], cex = 2.0, pch=25, col="black", bg="magenta")
points(mds$points[sample_full$pesticide == 'cypermethrin' & sample_full$concentration == 'x4', ], cex = 2.0, pch=24, col="black", bg="cyan")
points(mds$points[sample_full$pesticide == 'cypermethrin' & sample_full$concentration == 'x1', ], cex = 2.0, pch=25, col="black", bg="cyan")
points(mds$points[sample_full$day == 0, ], cex = 1.0, pch=21, col="black", bg="white")
points(mds$points[sample_full$day == 7, ], cex = 1.0, pch=21, col="black", bg="grey")
points(mds$points[sample_full$day == 56, ], cex = 1.0, pch=21, col="black", bg="black")

dev.off()


#################################################################
# constrainted ordination

pdf("13.CCA.pdf")

ord <- cca(t(log_otus) ~ pesticide + concentration + day, data = sample_full)
ord
summary(ord)
anova(ord)
anova(ord, by="term")
anova(ord, by="mar")
anova(ord, by="axis")
plot(ord)

ord_c_d <- cca(t(log_otus) ~ pesticide + concentration + Condition(day), data = sample_full)
anova(ord_c_d)
anova(ord_c_d, by="term")
anova(ord_c_d, by="mar")
anova(ord_c_d, by="axis")

ord_c_c <- cca(t(log_otus) ~ pesticide + Condition(concentration) + day, data = sample_full)
anova(ord_c_c)
anova(ord_c_c, by="term")
anova(ord_c_c, by="mar")

dev.off()

################################################################
# rarefaction

pdf("13.rarefaction.pdf")

raw_otus_t <- t(raw_otus)
S <- specnumber(raw_otus_t)
(raremax <- min(rowSums(raw_otus_t)))
Srare <- rarefy(raw_otus_t, raremax)
plot(S, Srare, xlab = "Observed No. of Species", ylab = "Rarefied No. of Species")
abline(0, 1)
rarecurve(raw_otus_t, step = 20, sample = raremax, col = "blue", cex = 0.6)

dev.off()

################################################################
# diversity

pdf("13.diversity.pdf")

H <- diversity(raw_otus_t, "shannon")
simp <- diversity(raw_otus_t, "simpson")
invsimp <- diversity(raw_otus_t, "inv")
## Unbiased Simpson (Hurlbert 1971, eq. 5) with rarefy:
unbias.simp <- rarefy(raw_otus_t, 2) - 1
## Fisher alpha
alpha <- fisher.alpha(raw_otus_t)
## Plot all
pairs(cbind(H, simp, invsimp, unbias.simp, alpha), pch="+", col="blue")
## Species richness (S) and Pielou's evenness (J):
S <- specnumber(raw_otus_t) ## rowSums(raw_otus_t > 0) does the same...
J <- H/log(S)

barplot(H)
barplot(simp)
barplot(invsimp)
barplot(alpha)

dev.off()
