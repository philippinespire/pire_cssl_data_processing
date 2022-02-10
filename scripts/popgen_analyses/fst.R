#pixy script
#from https://pixy.readthedocs.io/en/latest/plotting.html

remove(list = ls())

#load libraries
library(tidyverse)
library(boot)

#read in data
fst <- read.table("pixy/pixy_fst.txt", header = TRUE)

###############################################################################################

#data exploration

#subset to within-species comparison
#create dataframes for each pop
Ela.fst <- subset(fst, pop1 == "Ela-AHam" & pop2 == "Ela-CNas") #6909 windows

#pull out windows with fst > 0.15
Ela.fst.potoutliers <- subset(Ela.fst, avg_wc_fst >= 0.15)
  Ela.fst.potoutliers <- Ela.fst.potoutliers[order(Ela.fst.potoutliers$avg_wc_fst, decreasing = TRUE),]

#coarse visualization
Ela.fst$NUM <- c(1:6909) #just assigning each window a number so can plot

fst_plot <- ggplot(data = Ela.fst, aes(x = NUM, y = avg_wc_fst)) + 
  geom_point(color = "black") + geom_hline(yintercept = 0.15, color = "black", size = 1, linetype = "dashed")
fst_plot_annotated <- fst_plot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
        axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 14, color = "black"),
        axis.title = element_text(size = 14, face = "bold"), legend.position = "top", 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))
fst_plot_annotated

#filter by pop 1 & pop 2
#plot fst across windows (just give each window a number) --> really only interested in Ela comparison

