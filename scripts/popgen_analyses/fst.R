#################################################### Script for Calculating Fst  ########################################################

#adjust paths as needed
#calculates fst over windows (pixy), pair-wise & per-locus (both with hierfstat from raw vcf)

#################################################################################################################################################

######## Set-up ########

#### set working directory ####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

remove(list = ls()) #clear working env

#### load libraries ####
library(tidyverse)
library(vcfR)
library(adegenet)
library(hierfstat)

#read in data
fst <- read.table("PIRE_Aen_Ham/pixy/pixy_fst.txt", header = TRUE)
vcf <- read.vcfR("PIRE_Aen_Ham/Aen.postAB_HD2.5.rad.RAW-6-6.Fltr17.11.recode.vcf")
  genind <- vcfR2genind(vcf) #convert to genind object for hierfstat analyses

###############################################################################################################################################

######## Visualize pixy results ########
#pixy calculates fst in windows

#subset to within-species comparison (may not need to do this if only have one species in dataset)
#Ela.fst <- subset(fst, pop1 == "Ela-AHam" & pop2 == "Ela-CNas")

#### create scatterplot ####
fst$NUM <- c(1:6909) #assign each window a number so can plot (1:nrows)

fst_plot <- ggplot(data = fst, aes(x = NUM, y = avg_wc_fst)) + 
  geom_point(color = "black") + geom_hline(yintercept = 0.15, color = "black", size = 1, linetype = "dashed")
fst_plot_annotated <- fst_plot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
        axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 14, color = "black"),
        axis.title = element_text(size = 14, face = "bold"), legend.position = "top", 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))
fst_plot_annotated

###############################################################################################################################################

######## Fst estimates from VCF ########

#add population level data
pop(genind) <- c(rep(1, times = 60), rep(2, times = 95)) #1 = Albatross, 2 = Contemporary

######## Calculate per-locus Fst ########

#calculate diversity metrics w/in pops
sum_stats <- basic.stats(genind)

#pull out Fst per locus
stats_perloc <- data.frame(sum_stats$perloc)

#### create scatter plot ####
stats_perloc$NUM <- c(1:3335) #number of rows (loci) in sum_stats
  
fst_plot <- ggplot(data = stats_perloc, aes(x = NUM, y = Fst)) + 
   geom_point(color = "black") + geom_hline(yintercept = 0.15, color = "black", size = 1, linetype = "dashed")
fst_plot_annotated <- fst_plot + theme_bw() + 
   theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
         axis.ticks = element_line(color = "black", size = 1), 
         axis.text = element_text(size = 14, color = "black"),
         axis.title = element_text(size = 14, face = "bold"), legend.position = "top", 
         legend.text = element_text(size = 12), legend.title = element_text(size = 12))
fst_plot_annotated
  
######## Calculate pairwise-Fst ########
  
hierf <- genind2hierfstat(genind) #convert to hierfstat db for pairwise analyses
pairwise_fst <- genet.dist(hierf, method = "WC84") #calculates Weir & Cockerham's Fst
  
#### bootstrap pairwise_fst for 95% CI ####
  
#need to convert pop character to numeric for bootstrap to work
hierf$pop <- as.numeric(hierf$pop)
  class(hierf$pop) #check to make sure numeric
  
#bootstrap pairwise estimates
pairwise_boot <- boot.ppfst(dat = hierf, nboot = 1000, quant = c(0.025, 0.975), diploid = TRUE)
  
#get 95% CI limits
ci_upper <- pairwise_boot$ul
ci_lower <- pairwise_boot$ll
