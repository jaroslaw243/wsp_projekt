library(Biobase)
library(affy)
library(estrogen)
library(hgu95av2)
library(hgu95av2cdf)
library(gahgu95av2.db)
library(gcrm)
library(tkWidgets)
library(hgu95av2.db)

setwd("C:/Users/domin/Downloads/CEL")

f<-list.files(pattern = ".CEL")
raw_data <- ReadAffy(widget=TRUE, cdfname = "hgu95av2cdf")
  data_rma_norm = affy::rma(raw_data)
  data_mas_norm = mas5(raw_data)
  data_gcrma_norm = gcrma(raw_data)

data_medians <- rowMedians(Biobase::exprs(data_rma_norm))

man_threshold <- 5

hist_res <- hist(data_medians, 500, col = "cornsilk", freq = FALSE,
                 main = "Histogram of the median intensities",
                 border = "antiquewhite4",
                 xlab = "Median intensities")

abline(v = man_threshold, col = "coral4", lwd = 2)

no_of_samples <-
  table(paste0(pData(data_rma_norm)$Factor.Value.disease., "_",
               pData(data_rma_norm)$Factor.Value.phenotype.))
no_of_samples

samples_cutoff <- min(no_of_samples)

idx_man_threshold <- apply(Biobase::exprs(data_rma_norm), 1,
                           function(x){
                             sum(x > man_threshold) >= samples_cutoff})
table(idx_man_threshold)
data_manfiltered <- subset(data_rma_norm, idx_man_threshold)

rma = exprs(data_manfiltered)
write.table(rma, file = "rma.txt", quote = FALSE, sep = "\t")

probes=row.names(rma)

ls("package:hgu95av2")
Symbols = unlist(mget(probes, hgu95av2SYMBOL, ifnotfound=NA))
Entrez_IDs = unlist(mget(probes, hgu95av2ENTREZID, ifnotfound=NA))
rma=cbind(probes,Symbols,Entrez_IDs,rma)
write.table(rma, file = "annotation.txt", quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)

dataNormalized = data_manfiltered
