hc=function(dane,liczba_gen,miara_odl,metoda_polacz,liczba_grup){
  
  #funkcja realizuj¹ca klasteryzacjê hierarchiczn¹
  
  #Przyk³adowe parametry wywo³uj¹ce funkcjê:
  #liczba_grup=5
  #liczba_gen=10
  #metoda_polacz='complete'
  #miara_odl='euclidean'
  
  #wczytywanie bibliotek
   library(dendextend)
   library(factoextra)
   library(ggdendro)
   library(colorspace)
   library(heatmaply)
   library(stringr)
   library(gplots) 
   #BiocManager::install('ggplots')
  
  data.matrix = exprs(dane)
  wariancje <- as.matrix(apply(data.matrix,1,var))
  wariancjeposort <- order(wariancje,decreasing = TRUE)
  
  daneHeatmapa <- data.matrix[wariancjeposort[1:liczba_gen],]
  #plot(daneHeatmapa)
  
  skala <- (scale(t(daneHeatmapa)))
  
  #klasteryzacja
  d <- dist(skala, method = miara_odl)
  hc <- hclust(d, method =metoda_polacz)
  # plot(hc)
  
  rc <- colorspace::rainbow_hcl(liczba_grup)
  podgrupy <- cutree(hc, k = liczba_grup)
  klastry=fviz_cluster(list(data = skala, cluster = podgrupy), palette = rc)
  
  klastry
  p4=ggplotly(klastry)
  
  for (i in 2:(length(p4[["x"]][["data"]])/2) ){
    p4[["x"]][["data"]][[i]][["name"]] <-str_remove_all(p4[["x"]][["data"]][[i]][["name"]],'[(,1,NA)]')
    p4[["x"]][["data"]][[i]][["legendgroup"]]=str_remove_all(p4[["x"]][["data"]][[i]][["name"]],'[(,1,NA)]')
    
  }
  for (i in ((length(p4[["x"]][["data"]])/2)+1): length(p4[["x"]][["data"]])){
    p4[["x"]][["data"]][[i]][["showlegend"]]=F
    p4[["x"]][["data"]][[i]][["legendgroup"]]=str_remove_all(p4[["x"]][["data"]][[i]][["name"]],'[(,1,NA)]')
    p4[["x"]][["data"]][[16]][["legendgroup"]]='1'; p4[["x"]][["data"]][[16]][["name"]]='1'
  }
  
  
  klastry=p4
  paleta=c()
  for(w in 1:liczba_grup){
    paleta=c(paleta,(rc[w]))
  }
  
  names(paleta)=c(1:liczba_grup)
  
  p <- heatmaply(daneHeatmapa,dendrogram = c("both"),dist_method = miara_odl,hclust_method = metoda_polacz,show_dendrogram = c(TRUE, TRUE),Colv = hc,row_dend_left=F,label_names = c("Gene", "Sample",'value'),margins = c(60,100,40,20),
                 #grid_color = "white",
                 #grid_width = 0.00001,
                 hide_colorbar = T,branches_lwd = 0.1,col_side_colors = podgrupy,col_side_palette = paleta,trace='none'
  )
  
  return(list(klastry,p))
}