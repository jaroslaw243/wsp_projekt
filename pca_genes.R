pca_genes <- function(dataNormalized){
  dataExprs <- as.data.frame(dataNormalized)
  pca <- prcomp(t(dataExprs))
  pc1 <- pca$x[, 1]
  pc2 <- pca$x[, 2]
  Klasy <- colnames(dataExprs)
  nazwy <- unique(colnames(dataExprs))
  numeracja <- seq_len(ncol(dataExprs))

  for(j in seq_along(nazwy)){
    for(i in seq_len(ncol(dataExprs))){
      if(Klasy[i]==nazwy[j]){
        numeracja[i] <- j}
    }
  }

  df_out <- as.data.frame(pca$x)
  p1 <- ggplot(df_out, aes(x=pc1, y=pc2, color=Klasy))
  p1 <- p1 + geom_point() + ggtitle("Wykres PCA")

  p2 <- fviz_eig(pca)
  return(list(p1, p2, df_out))
}
