setwd("C:/Users/Adrian/Desktop/Magisterka/WSP/Kod_R")

slide <- function (x1, x2, x3, x4, x5)
{
  library(officer)
  pres <- read_pptx(path = "Szablon.pptx")
  pres <- on_slide(pres, index = 1)
  paragraph <- fpar(ftext("Raport", fp_text(color = "black", font.size = 40, bold = TRUE)))
  pres <- ph_with(pres, value = paragraph, location = ph_location(left = 5.5,top = 0.3,width = 6,height = 2))
  pres <- ph_with(pres, value = x1, location = ph_location(left = 1,top = 1.5,width = 5,height = 5))
  pres <- ph_with(pres, value = x2, location = ph_location(left = 7.3,top = 1.5,width = 5,height = 5))
  
  
  pres <- on_slide(pres, index = 2)
  paragraph2 <- fpar(ftext("Wartosci wlasne", fp_text(color = "black", font.size = 30, bold = TRUE)))
  pres <- ph_with(pres, value = paragraph2, location = ph_location(left = 8.2,top = 0.7,width = 4,height = 0.5))
  pres <- ph_with(pres, value = x3, location = ph_location(left = 7.3,top = 1.5,width = 5,height = 4.5))
  pres <- ph_with(pres, value = x4, location = ph_location(left = 1,top = 2, width = 5.5,height = 4))
  
  pres <- on_slide(pres, index = 3)
  pres <- ph_with(pres, value = x5, location = ph_location(left = 2.5,top = 1.1,width = 8,height = 5))
  
  print(pres, target = "Raport.pptx")
}

library(ggplot2)
x33 <- data.frame(a = 1:5, b = 6:10, c = 11:15)
x11 <- ggplot(data = x33) + geom_point(mapping = aes(1:5, a), size = 3) + theme_minimal()
x22 <- ggplot(data = x33) + geom_point(mapping = aes(1:5, a), size = 3) + theme_minimal()
x44 <- ggplot(data = x33) + geom_point(mapping = aes(1:5, a), size = 3) + theme_minimal()
x55 <- ggplot(data = x33) + geom_point(mapping = aes(1:5, a), size = 3) + theme_minimal()
x <-slide(x11,x22,x33,x44,x55)
