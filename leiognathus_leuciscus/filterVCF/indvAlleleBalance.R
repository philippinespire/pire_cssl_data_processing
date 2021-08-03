


#### Initialize ####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(magrittr)
library(janitor)

#### Set Variables ####
alleledepthFILE = 'lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.100.AD.tsv'
genolikelihoodFILE = 'lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.100.GL.tsv'
genoFILE = 'lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.100.GT.tsv'

#### READ in DATA ####
allele_depth <-
  read_tsv(alleledepthFILE) %>%
    clean_names()
