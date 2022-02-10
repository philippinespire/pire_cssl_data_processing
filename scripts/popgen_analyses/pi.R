#pixy script
#from https://pixy.readthedocs.io/en/latest/plotting.html

remove(list = ls())

#load libraries
library(tidyverse)
library(boot)

#read in data
pi <- read.table("pixy/pixy_pi.txt", header = TRUE)

###############################################################################################

#data exploration
#testing to determine appropriate cut-off (how many sites need to be genotyped in a window to get reliable estimate of pi?)

#create dataframes for each pop
Lle.AHam.pi <- subset(pi, pop == "Lle-AHam" & avg_pi != "NA")
  Lle.AHam.100bp.pi <- subset(pi, pop == "Lle-AHam" & avg_pi != "NA" & no_sites > 120)
Ela.AHam.pi <- subset(pi, pop == "Ela-AHam" & avg_pi != "NA")
  Ela.AHam.100bp.pi <- subset(pi, pop == "Ela-AHam" & avg_pi != "NA" & no_sites > 120)
Ela.CNas.pi <- subset(pi, pop == "Ela-CNas" & avg_pi != "NA")
  Ela.CNas.100bp.pi <- subset(pi, pop == "Ela-CNas" & avg_pi != "NA" & no_sites > 10)

#calculate mean pi
Lle.AHam.pi.mean <- mean(Lle.AHam.pi$avg_pi)
  Lle.AHam.100bp.pi.mean <- mean(Lle.AHam.100bp.pi$avg_pi)
Ela.AHam.pi.mean <- mean(Ela.AHam.pi$avg_pi)
  Ela.AHam.100bp.pi.mean <- mean(Ela.AHam.100bp.pi$avg_pi)
Ela.CNas.pi.mean <- mean(Ela.CNas.pi$avg_pi)
  Ela.CNas.100bp.pi.mean <- mean(Ela.CNas.100bp.pi$avg_pi)

#calculate median pi
Lle.AHam.pi.median <- median(Lle.AHam.pi$avg_pi)
  Lle.AHam.100bp.pi.median <- median(Lle.AHam.100bp.pi$avg_pi)
Ela.AHam.pi.median <- median(Ela.AHam.pi$avg_pi)
  Ela.AHam.100bp.pi.median <- median(Ela.AHam.100bp.pi$avg_pi)
Ela.CNas.pi.median <- median(Ela.CNas.pi$avg_pi)
  Ela.CNas.100bp.pi.median <- median(Ela.CNas.100bp.pi$avg_pi)

#boxplots

#ordering x-axis
pi$pop <- factor(pi$pop, levels = c("Lle-AHam", "Ela-AHam", "Ela-CNas"))

#boxplot
pi_boxplot <- ggplot(data = pi, aes(x = pop, y = avg_pi)) + 
  geom_boxplot()
pi_boxplot_annotated <- pi_boxplot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1),
        axis.ticks = element_line(color = "black", size = 1), 
        axis.title = element_text(size = 14, face = "bold"), legend.position = "top",
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))
pi_boxplot_annotated

#plot pi v. no_sites
#do longer regions (with more called monomorphic sites basically have lower pi)

Lle_AHam_scatterplot <- ggplot(data = Lle.AHam.pi, aes(x = no_sites, y = avg_pi)) + 
  geom_point()
Lle_AHam_scatterplot_annotated <- Lle_AHam_scatterplot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1),
        axis.ticks = element_line(color = "black", size = 1), 
        axis.title = element_text(size = 22, face = "bold"), legend.position = "top",
        axis.text = element_text(size = 14),
        legend.text = element_text(size = 18), legend.title = element_text(size = 12))
Lle_AHam_scatterplot_annotated

#if only called a few sites, almost exclusively higher pi --> makes sense
#reduce to regions with at least 100 sites called (probe targets?)
#probe targets are ~120 bp in length, so 100 sites = most of that probe region is called

#scatterplots of mean & median
#write vectors
min_num_sites <- c(0, 10, 20, 30, 40, 50, 100, 120, 
                   0, 10, 20, 30, 40, 50, 100, 120, 
                   0, 10, 20, 30, 40, 50, 100, 120)
pop <- c(rep("Lle.AHam", 8), rep("Ela.AHam", 8), rep("Ela.CNas", 8))
mean <- c(0.0465, 0.0024, 0.0032, 0.0024, 0.0023, 0.0023, 0.0024, 0.0024, 
          0.0699, 0.0285, 0.0057, 0.004, 0.0039, 0.0039, 0.004, 0.004, 
          0.0645, 0.0277, 0.0054, 0.0037, 0.0037, 0.0037, 0.0038, 0.0038)
median <- c(0.0084, 0.0018, 0.0009, 0.0009, 0.001, 0.001, 0.0012, 0.0013, 
            0.0349, 0.0039, 0.0023, 0.0023, 0.0023, 0.0024, 0.0028, 0.0028, 
            0.0346, 0.0037, 0.0022, 0.0022, 0.0022, 0.0023, 0.0026, 0.0028)

pi_test_df <- as.data.frame(cbind(pop, min_num_sites, mean, median))
  pi_test_df$min_num_sites <- as.character(pi_test_df$min_num_sites)
    pi_test_df$min_num_sites <- as.numeric(pi_test_df$min_num_sites)
  pi_test_df$mean <- as.character(pi_test_df$mean)
    pi_test_df$mean <- as.numeric(pi_test_df$mean)
  pi_test_df$median <- as.character(pi_test_df$median)
    pi_test_df$median <- as.numeric(pi_test_df$median)

pi_mean_scatterplot <- ggplot(data = pi_test_df, aes(x = min_num_sites, y = mean, color = pop, group = pop)) + 
  geom_point(size = 5) + geom_line(linetype = "solid", size = 2) + ylim(0, 0.1)
pi_mean_scatterplot_annotated <- pi_mean_scatterplot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1),
        axis.ticks = element_line(color = "black", size = 1), 
        axis.title = element_text(size = 22, face = "bold"), legend.position = "top",
        axis.text = element_text(size = 14), 
        legend.text = element_text(size = 18), legend.title = element_text(size = 18))
pi_mean_scatterplot_annotated

pi_median_scatterplot <- ggplot(data = pi_test_df, aes(x = min_num_sites, y = median, color = pop, group = pop)) + 
  geom_point(size = 5) + geom_line(linetype = "solid", size = 2) + ylim(0, 0.1)
pi_median_scatterplot_annotated <- pi_median_scatterplot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1),
        axis.ticks = element_line(color = "black", size = 1), 
        axis.title = element_text(size = 22, face = "bold"), legend.position = "top",
        axis.text = element_text(size = 14), 
        legend.text = element_text(size = 18), legend.title = element_text(size = 18))
pi_median_scatterplot_annotated

#scatterplot of num sequences
#write vectors
min_num_sites <- c(0, 10, 20, 30, 40, 50, 100, 120)
num_sequences <- c(7550, 3445, 2671, 2542, 2445, 2359, 1814, 1590)

numseq_df <- as.data.frame(cbind(min_num_sites, num_sequences))
  numseq_df$min_num_sites <- as.character(numseq_df$min_num_sites)
    numseq_df$min_num_sites <- as.numeric(numseq_df$min_num_sites)
  numseq_df$num_sequences <- as.character(numseq_df$num_sequences)
   numseq_df$num_sequences <- as.numeric(numseq_df$num_sequences)

numseq_scatterplot <- ggplot(data = numseq_df, aes(x = min_num_sites, y = num_sequences)) + 
  geom_point(size = 5)
numseq_scatterplot_annotated <- numseq_scatterplot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1),
        axis.ticks = element_line(color = "black", size = 1), 
        axis.title = element_text(size = 22, face = "bold"), legend.position = "top",
        axis.text = element_text(size = 14), 
        legend.text = element_text(size = 18), legend.title = element_text(size = 24))
numseq_scatterplot_annotated

######################################################################################

######### pi estimates ######## 

#subsetting dataframe to windows with >100 genotyped sites
pi.100bp <- subset(pi, no_sites >= 100) #left with 5469 windows

#create dataframe for each pop
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

####################################################################################

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