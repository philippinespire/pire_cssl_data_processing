#################################################### Script for Calculating & Bootstrapping mean pi  ########################################################

#adjust paths as needed
#other code available at https://pixy.readthedocs.io/en/latest/plotting.html

############################################################################################################################################################

######## Set-up ########

#### set working directory ####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

remove(list = ls()) #clear working env

#### load libraries ####
library(tidyverse)
library(boot)

##### read in data ####
pi <- read.table("pixy/pixy_pi.txt", header = TRUE)

################################################################################################################################################################

######### Pi estimates ######## 

#subsetting dataframe to windows with >100 genotyped sites
pi.100bp <- subset(pi, no_sites >= 100)

#create dataframe for each pop
#change names (and add lines) as necessary
Lle.AHam.pi.100bp <- subset(pi.100bp, pop == "Lle-AHam")
Ela.AHam.pi.100bp <- subset(pi.100bp, pop == "Ela-AHam")
Ela.CNas.pi.100bp <- subset(pi.100bp, pop == "Ela-CNas")

#### calculate mean & median pi/pop ####
#calculate mean pi
Lle.AHam.pi.100bp.mean <- mean(Lle.AHam.pi.100bp$avg_pi)
Ela.AHam.pi.100bp.mean <- mean(Ela.AHam.pi.100bp$avg_pi)
Ela.CNas.pi.100bp.mean <- mean(Ela.CNas.pi.100bp$avg_pi)

#calculate median pi
Lle.AHam.pi.100bp.median <- median(Lle.AHam.pi.100bp$avg_pi)
Ela.AHam.pi.100bp.median <- median(Ela.AHam.pi.100bp$avg_pi)
Ela.CNas.pi.100bp.median <- median(Ela.CNas.pi.100bp$avg_pi)

#### pi bootstrapping ####
#write function to calculate mean
samp_mean <- function(x, i) {
  mean(x[i])
}

#bootstrap for Lle Albatross
boot.Lle.AHam.pi.100bp <- boot(data = Lle.AHam.pi.100bp$avg_pi, statistic = samp_mean, R = 1000) #1000 permutations of pi
Lle.AHam.pi.100bp.95ci <- boot.ci(boot.Lle.AHam.pi.100bp, conf = 0.95, type = "norm")
Lle.AHam.pi.100bp.95ci.normal <- Lle.AHam.pi.100bp.95ci$normal

#bootstrap for Ela Albatross
boot.Ela.AHam.pi.100bp <- boot(data = Ela.AHam.pi.100bp$avg_pi, statistic = samp_mean, R = 1000) #1000 permutations of pi
Ela.AHam.pi.100bp.95ci <- boot.ci(boot.Ela.AHam.pi.100bp, conf = 0.95, type = "norm")
Ela.AHam.pi.100bp.95ci.normal <- Ela.AHam.pi.100bp.95ci$normal

#bootstrap for Ela Contemporary
boot.Ela.CNas.pi.100bp <- boot(data = Ela.CNas.pi.100bp$avg_pi, statistic = samp_mean, R = 1000) #1000 permutations of pi
Ela.CNas.pi.100bp.95ci <- boot.ci(boot.Ela.CNas.pi.100bp, conf = 0.95, type = "norm")
Ela.CNas.pi.100bp.95ci.normal <- Ela.CNas.pi.100bp.95ci$normal

####################################################################################################################################################

######### Visualize results ########

#ordering x-axis
pi.100bp$pop <- factor(pi.100bp$pop, levels = c("Lle-AHam", "Ela-AHam", "Ela-CNas"))

#boxplot
pi_boxplot <- ggplot(data = pi.100bp, aes(x = pop, y = avg_pi)) + 
  geom_boxplot()
pi_boxplot_annotated <- pi_boxplot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1),
        axis.ticks = element_line(color = "black", size = 1), 
        axis.title = element_text(size = 14, face = "bold"), legend.position = "top",
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))
pi_boxplot_annotated
