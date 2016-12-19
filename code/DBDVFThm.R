#DBDVFThm
#Data Visulization Final Theme
require('ggplot2')
#require('extrafont')
#loadfonts(quiet = TRUE)

DBDVFThm <- theme(
  #light gridlines on  blue background
  panel.grid.major = element_line(color = '#D4DFE6'),
  panel.background = element_rect(fill = '#6AAFE6'),
  
  #remove tickmarks and minor grid lines
  axis.ticks = element_blank(),
  panel.grid.minor = element_blank(),
  
  #add padding to chart and make background medium blue
  plot.margin = unit(c(15, 15, 15, 15), 'point'),
  plot.background = element_rect(fill = '#6AAFE6'),
  
  #set axis text
  axis.text = element_text(color = '#CADBE9', size = 12),
  axis.title = element_text(size = 14, face='bold'),
  
  #position titles and labels
  plot.title = element_text(hjust = 0, margin = margin(0,0,20,0), size = 22, face='bold'),
  axis.title.x = element_text(margin = margin(15,0,0,0)),
  axis.title.y = element_text(margin = margin(15,20,0,0)),
  
  #legend styling
  legend.background = element_rect(fill = NA, color = '#8EC0E4'),
  legend.key = element_rect(fill = NA ,color = NA),
  legend.margin = unit(15, 'pt')#,
  #legend.position = 'none'
)