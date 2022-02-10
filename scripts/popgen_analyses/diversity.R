################################################### Script for Genetic Diversity Estimates  #######################################################

#calculates Ho & He from (ideally LD-pruned) VCF
#adjust paths as needed

#################################################################################################################################################

######## Set-up ########

#set working directory
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
#getwd()

remove(list = ls())

#load libraries
library(adegenet)
library(pegas)
library(hierfstat)
library(tidyverse)
library(boot)
library(vcfR)

#read in data
vcf <- read.vcfR("PIRE_Aen_Ham/Aen.postAB_HD2.5.rad.RAW-6-6.Fltr17.11.recode.vcf")
  genind <- vcfR2genind(vcf) #convert to genind object for analyses

################################################################################################################################################

######## Ho & He estimates ########

#add population level data
pop(genind) <- c(rep(1, times = 60), rep(2, times=95)) #1 = Albatross, 2 = Contemporary
  
#calculate diversity metrics w/in pops  
sum_stats <- basic.stats(genind)
  
#mean Ho & He for each population
Ho_means <- colMeans(sum_stats$Ho)
Hs_means <- colMeans(sum_stats$Hs)
  
#pull out Ho for each population
Alb_Ho <- sum_stats$Ho[,1]
Contemp_Ho <- sum_stats$Ho[,2]
  
#pull out He for each population
Alb_He <- sum_stats$Hs[,1]
Contemp_He <- sum_stats$Hs[,2]
  
#bind Ho & He into dataframe for each pop
Alb_div <- as.data.frame(cbind(Alb_Ho, Alb_He))
head(Alb_div) #check content is right
colnames(Alb_div) <- c("Ho", "He")
  
Contemp_div <- as.data.frame(cbind(Contemp_Ho, Contemp_He))
colnames(Contemp_div) <- c("Ho", "He")
  
#write out (if want, need this format for bootstrapping CIs)
#write.csv(Alb_div, "../PIRE_Aen_Ham/Alb_div.csv", quote = FALSE, row.names = TRUE)
#write.csv(Contemp_div, "../PIRE_Aen_Ham/Contemp_div.csv", quote = FALSE, row.names = TRUE)
  
######## Ho & He bootstrapping ########
  
#read in if running separately
#Alb_div <- read.csv("../PIRE_Aen_Ham/Alb_div.csv")
  #dim(Alb_div)
  #colnames(Alb_div) <- c("locus", "Ho", "He")
#Contemp_div <- read.csv("../PIRE_Aen_Ham/Contemp_div.csv")
  #colnames(Contemp_div) <- c("locus", "Ho", "He")
  
#write function to calculate mean
samp_mean <- function(x, i) {
   mean(x[i])
  }
  
#bootstrap for Albatross Ho
boot_Alb_Ho <- boot(data = Alb_div$Ho, statistic = samp_mean, R = 1000) #1000 permutations of Ho
Alb_Ho_95ci <- boot.ci(boot_Alb_Ho, conf = 0.95, type = "norm") #get 95% CI for Ho
Alb_Ho_95ci_normal <- Alb_Ho_95ci$normal #pull out normal distribution 2.5 & 97.5 percentiles for Ho
  
#bootstrap for Contemporary Ho
boot_Contemp_Ho <- boot(data = Contemp_div$Ho, statistic = samp_mean, R = 1000)
Contemp_Ho_95ci <- boot.ci(boot_Contemp_Ho, conf = 0.95, type = "norm")
Contemp_Ho_95ci_normal <- Contemp_Ho_95ci$normal
  
#bootstrap for Albatross He
boot_Alb_He <- boot(data = Alb_div$He, statistic = samp_mean, R = 1000)
Alb_He_95ci <- boot.ci(boot_Alb_He, conf = 0.95, type = "norm")
Alb_He_95ci_normal <- Alb_He_95ci$normal
  
#bootstrap for Contemporary He
boot_Contemp_He <- boot(data = Contemp_div$He, statistic = samp_mean, R = 1000)
Contemp_He_95ci <- boot.ci(boot_Contemp_He, conf = 0.95, type = "norm")
Contemp_He_95ci_normal <- Contemp_He_95ci$normal
