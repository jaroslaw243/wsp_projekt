slide <- function (x1, x2, x3, x4, x5)
{
  pres <- read_pptx(path = "Szablon.pptx")
  paragraph <- fpar(ftext("Raport", fp_text(color = "black", font.size = 40, bold = TRUE)))
  pres <- ph_with(pres, value = paragraph, location = ph_location(left = 5,top = 0.5,width = 6,height = 2))
  pres <- ph_with(pres, value = x1, location = ph_location(left = 8.2,top = 4.5,width = 4,height = 2))
  pres <- ph_with(pres, value = x2, location = ph_location(left = 1,top = 1.5,width = 3,height = 2), bg = "lightblue")
  pres <- ph_with(pres, value = x3, location = ph_location(left = 9.2,top = 1.2, width = 4,height = 2))
  pres <- ph_with(pres, value = x4, location = ph_location(left = 4.5,top = 1.5,width = 3,height = 2), bg = "lightblue")
  pres <- ph_with(pres, value = x5, location = ph_location(left = 1,top = 4,width = 6,height = 3), bg = "lightblue")
  print(pres, target = "Raport.pptx")
}
