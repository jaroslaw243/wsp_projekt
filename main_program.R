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
raw.data = Data
  data.rma.norm = rma(raw.data)
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