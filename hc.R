hc <- function(dane, liczba_gen, miara_odl, metoda_polacz, liczba_grup) {
  data.matrix <- dane
  wariancje <- as.matrix(apply(data.matrix, 1, var))
  wariancjeposort <- order(wariancje, decreasing = TRUE)

  daneHeatmapa <<- data.matrix[wariancjeposort[1:liczba_gen],]

  skala <- (scale(t(daneHeatmapa)))

  # klasteryzacja
  d <- dist(skala, method = miara_odl)
  hc <- hclust(d, method = metoda_polacz)

  rc <- colorspace::rainbow_hcl(liczba_grup)
  podgrupy <- cutree(hc, k = liczba_grup)
  klastry <- fviz_cluster(list(data = skala, cluster = podgrupy), palette = rc)

  p4 <- ggplotly(klastry)
  klastry_2 <- klastry

  for (i in 2:(length(p4[["x"]][["data"]])/2) ){
    p4[["x"]][["data"]][[i]][["name"]] <- str_remove_all(p4[["x"]][["data"]][[i]][["name"]], '[(,1,NA)]')
    p4[["x"]][["data"]][[i]][["legendgroup"]] <- str_remove_all(p4[["x"]][["data"]][[i]][["name"]], '[(,1,NA)]')

  }
  for (i in ((length(p4[["x"]][["data"]])/2)+1): length(p4[["x"]][["data"]])){
    p4[["x"]][["data"]][[i]][["showlegend"]] <- F
    p4[["x"]][["data"]][[i]][["legendgroup"]] <- str_remove_all(p4[["x"]][["data"]][[i]][["name"]], '[(,1,NA)]')
    p4[["x"]][["data"]][[liczba_grup]][["legendgroup"]] <- '1'; p4[["x"]][["data"]][[liczba_grup]][["name"]] <- '1'
  }

  klastry <- p4
  paleta <- c()
  for (w in 1:liczba_grup) {
    paleta <- c(paleta, (rc[w]))
  }

  names(paleta) <- c(1:liczba_grup)

  p <- heatmaply(daneHeatmapa, dendrogram = c("both"), dist_method = miara_odl, hclust_method = metoda_polacz,
                 show_dendrogram = c(TRUE, TRUE), Colv = hc, row_dend_left = F, label_names = c("Gen", "Probka", " Wartosc"),
                 margins = c(60, 100, 40, 20),
                 #grid_color = "white",
                 #grid_width = 0.00001,
                 hide_colorbar = F, branches_lwd = 0.1, col_side_colors = podgrupy, col_side_palette = paleta,
                 trace = 'none', labRow = unlist(mget(rownames(daneHeatmapa), hgu95av2SYMBOL, ifnotfound='???'))
  )

  png('hmp_temp.png', width = 2000, height = 2000, res = 250)
  heatmap.2(as.matrix(daneHeatmapa), dendrogram = c("both"),
            distfun = function(x) dist(x, method = miara_odl),
            hclustfun = function(x2) hclust(x2, method = metoda_polacz), scale = "none",
            col = bluered(100), trace = "none", density.info = "none",
            labRow = unlist(mget(rownames(daneHeatmapa), hgu95av2SYMBOL, ifnotfound='???')), cexCol = 0.7, srtCol = 30)
  dev.off()

  p_2 <- external_img('./hmp_temp.png')

  return(list(klastry, p, klastry_2, p_2))
}
