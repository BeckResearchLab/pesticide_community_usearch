library(vegan)

md <- read.delim("sample_info.xls", header=T, row.names=1, sep='\t');
head(md)

d <- read.delim("11.best_tax.xls", header=T, row.names=1, sep="\t")

otus <- read.delim("pesticide_community.log_normalized.xls", header=T, row.names=1, sep='\t')[,1:24]
sample_otus <- t(otus)

sample_full <- data.frame(sample_otus, pesticide = md$pesticide, day = md$day, concentration = md$concentration)

mds <- metaMDS(sample_otus, maxit=1000, trymax=100)
mds

#ord_o <- cca(sample_otus ~ cage + mouse + week + gender, data = sample_full)
#ord_o
#summary(ord_o)

#ord <- cca(sample_otus ~ diet + Animal + Week + Gender, data = sample_full)
#anova(ord)
#anova(ord, by="term")
#anova(ord, by="mar")
#anova(ord, by="axis")

#ord_c_c <- cca(sample_otus ~ Condition(diet) + Replicate + Week, data = sample_full)
#anova(ord_c_c)
#anova(ord_c_c, by="term")
#anova(ord_c_c, by="term", strata=diet)
#anova(ord_c_c, by="mar")
#anova(ord_c_c, by="axis")

mds$points
x=mds$points[sample_full$pesticide == 'control', 1]
y=mds$points[sample_full$pesticide == 'control', 2]

pdf("13.MDS.pdf")#, width=5, height=5);

plot(mds$points, type = "n", xlim=c(-.5, .6), ylim=c(-.5, .6))
points(x, y, cex = 2.0, pch=21, col="black", bg="black")
points(mds$points[sample_full$pesticide == 'chlorpyrifos', ], cex = 2.0, pch=21, col="black", bg="magenta")
points(mds$points[sample_full$pesticide == 'cypermethrin', ], cex = 2.0, pch=21, col="black", bg="cyan")
points(mds$points[sample_full$day == 0, ], cex = 1.0, pch=21, col="black", bg="white")
points(mds$points[sample_full$day == 7, ], cex = 1.0, pch=21, col="black", bg="grey")
points(mds$points[sample_full$day == 56, ], cex = 1.0, pch=21, col="black", bg="black")

#plot(ord_o, type="n")
#text(ord_o, display = "species", cex=.6)
#points(ord_o$CCA$wa[sample_full$diet == 'control diet', ], cex = 0.8, pch=21, col="black", bg="magenta")
#points(ord_o$CCA$wa[sample_full$diet == 'HVD diet', ], cex = 0.8, pch=21, col="black", bg="cyan")
#text(ord_o$CCA$wa[sample_full$diet == 'control diet', ] - 0.06, labels = rownames(sample_full)[sample_full$diet == 'control diet'], col="magenta", cex=.6)
#text(ord_o$CCA$wa[sample_full$diet == 'HVD diet', ] - 0.06, labels = rownames(sample_full)[sample_full$diet == 'HVD diet'], col="cyan", cex=.6)

dev.off()
