setwd("C:/Users/jarek/PycharmProjects/wsp_projekt")

library(affy)
library(gcrma)
library(hgu95av2)

abatch <- ReadAffy(filenames = c("data/CL2001031606AA.CEL", "data/CL2001031607AA.CEL",
                                 "data/CL2001031608AA.CEL", "data/CL2001031609AA.CEL"))

data.rma.norm <- rma(abatch)
data.mas.norm <- mas5(abatch)
data.gcrma.norm <- gcrma(abatch)

probes <- row.names(exprs(data.rma.norm))

Symbols <- unlist(mget(probes, hgu95av2SYMBOL, ifnotfound=NA))
Entrez_IDs <- unlist(mget(probes, hgu95av2ENTREZID, ifnotfound=NA))

data_norm <- exprs(data.rma.norm)
data_norm2 <- log2(exprs(data.mas.norm))
data_norm3 <- exprs(data.gcrma.norm)

# save(data.rma.norm, data.mas.norm, data.gcrma.norm, file = 'dane.RData')
save(data_norm, file = 'data_norm.RData')
write.csv(data_norm2, file = 'data_norm.csv')
write.xlsx(data_norm3, file = 'data_norm.xlsx')
