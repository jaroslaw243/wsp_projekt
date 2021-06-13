library(Biobase)
library(affy)
library(estrogen)
library(hgu95av2)
library(hgu95av2cdf)
library(gahgu95av2.db)
library(gcrm)
library(tkWidgets)


minMaxFilter <- function(arg)
{
  # tutaj będzie musiał powstać kod odpowiedzialny za filtrowanie
  # sond kontrolnych oraz 5% sond, o najmniejszej i największej
  # średniej ekspresji
}

setwd("C:/Users/domin/Downloads/CEL")

f<-list.files(pattern = ".CEL")
Data <- ReadAffy(widget=TRUE, cdfname = "hgu95av2cdf")
raw_data = Data
palmieri_eset_norm = affy::rma(raw.data)
  data.mas.norm = mas5(raw.data)
  data.gcrma.norm = gcrma(raw.data)
  myExpressionSet <- new("ExpressionSet",annotation = "hgu95av2")

rma = exprs(data.rma.norm)
write.table(rma, file = "rma.txt", quote = FALSE, sep = "\t")

probes=row.names(rma)

ls("package:hgu95av2.db")
Symbols = unlist(mget(probes, hgu95av2SYMBOL, ifnotfound=NA))
Entrez_IDs = unlist(mget(probes, hgu95av2ENTREZID, ifnotfound=NA))
rma=cbind(probes,Symbols,Entrez_IDs,rma)
write.table(rma, file = "annotation.txt", quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)

palmieri_medians <- rowMedians(Biobase::exprs(palmieri_eset_norm))

man_threshold <- 3.6
man_threshold1 <- 9.9

hist_res <- hist(palmieri_medians, 500, col = "cornsilk", freq = FALSE,
                 main = "Histogram of the median intensities",
                 border = "antiquewhite4",
                 xlab = "Median intensities")

abline(v = man_threshold, col = "coral4", lwd = 2)
abline(v = man_threshold1, col = "coral4", lwd = 2)

no_of_samples <-
  table(paste0(pData(palmieri_eset_norm)$Factor.Value.disease., "_",
               pData(palmieri_eset_norm)$Factor.Value.phenotype.))
no_of_samples

samples_cutoff <- min(no_of_samples)

idx_man_threshold <- apply(Biobase::exprs(palmieri_eset_norm), 1,
                           function(x){
                             sum(x > man_threshold) >= samples_cutoff})
table(idx_man_threshold)

