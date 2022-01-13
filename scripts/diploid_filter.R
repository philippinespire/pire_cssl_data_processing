#Modified from Chris's version (https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/indvAlleleBalance.R)
#To run for Aen & create a "greenlist" of loci that match diploidy assumptions for downstream analyses
#Filtering follow HDPlot guidelines written by McKinney et al. (2017) doi:10.1111/1755-0998.12613

#### Initialize ####

library(tidyverse)
library(magrittr)
library(janitor)

#### User Defined Variables ####
alleledepthFILE = 'noindels.biallelic.minQ20.minmeanDP10.nomonomorphic.maxmiss25.maxmissindv75.AD.tsv'
genoFILE = 'noindels.biallelic.minQ20.minmeanDP10.nomonomorphic.maxmiss25.maxmissindv75.GT.tsv'
indvPATTERN = "aen_"
modIdPATTERN = "_ae_.*"
het_cutoff_pop1 = 0.2125
het_cutoff_pop3 = 0.275

#### Calculate Variables ####
outDIR=dirname(genoFILE)
outFilePREFIX <-
  basename(genoFILE) %>%
  str_remove("GT.tsv")

#### Define Functions ####

getMode <- function(x) {
  keys <- 0:100 / 100
  keys[which.max(tabulate(match(round(x,
                                      2), 
                                keys)))]
}

# ex usage
# all_data %>%
# pull(allele_balance) %>%
# getMode()



#### READ in DATA ####
allele_depths <-
  read_tsv(alleledepthFILE,
           col_types=cols(.default = "c")) %>%
  clean_names() %>%
  pivot_longer(cols=contains(indvPATTERN),
               names_to="id") %>%
  separate(col=value,
           into=(c("num_reads_ref",
                   "num_reads_alt")),
           convert=TRUE) %>%
  mutate(num_reads = num_reads_alt + num_reads_ref)

# geno_likes <-
#   read_tsv(genolikelihoodFILE,
#            col_types=cols(.default = "c")) %>%
#   clean_names() %>%
#   pivot_longer(cols=contains(indvPATTERN),
#                names_to="id") %>%
#   separate(col=value,
#            into=(c("like_homo_ref",
#                    "like_hetero",
#                    "like_homo_alt")),
#            convert=TRUE)

#modified for octoploidy --> if diploid just remove extra states (state 3 and up)
genotypes <-
  read_tsv(genoFILE,
           col_types=cols(.default = "c")) %>%
  clean_names() %>%
  pivot_longer(cols=contains(indvPATTERN),
               names_to="id") %>%
  # mutate(value = str_replace_all(value,
  #                            pattern = "\\.",
  #                            replacement = "NA")) %>%
  separate(col=value,
           into=(c("state_1",
                   "state_2", 
                   "state_3", 
                   "state_4",
                   "state_5", 
                   "state_6",
                   "state_7",
                   "state_8"))) %>%
  mutate(state_1 = na_if(state_1,
                         ""),
         state_2 = na_if(state_2,
                         ""),
         state_3 = na_if(state_3,
                         ""),
         state_4 = na_if(state_4,
                         ""),
         state_5 = na_if(state_5,
                         ""),
         state_6 = na_if(state_6,
                         ""),
         state_7 = na_if(state_7,
                         ""),
         state_8 = na_if(state_8,
                         ""),
         genotype = case_when(state_1 != state_2 ~ "hetero", state_1 != state_3 ~ "hetero", state_1 != state_4 ~ "hetero", state_1 != state_5 ~ "hetero", state_1 != state_6 ~ "hetero", state_1 != state_7 ~ "hetero", state_1 != state_8 ~ "hetero",
                              state_2 != state_3 ~ "hetero", state_2 != state_4 ~ "hetero", state_2 != state_5 ~ "hetero", state_2 != state_6 ~ "hetero", state_2 != state_7 ~ "hetero", state_2 != state_8 ~ "hetero",
                              state_3 != state_4 ~ "hetero", state_3 != state_5 ~ "hetero", state_3 != state_6 ~ "hetero", state_3 != state_7 ~ "hetero", state_3 != state_8 ~ "hetero",
                              state_4 != state_5 ~ "hetero", state_4 != state_6 ~ "hetero", state_4 != state_7 ~ "hetero", state_4 != state_8 ~ "hetero",
                              state_5 != state_6 ~ "hetero", state_5 != state_7 ~ "hetero", state_5 != state_8 ~ "hetero",
                              state_6 != state_7 ~ "hetero", state_6 != state_8 ~ "hetero",
                              state_7 != state_8 ~ "hetero",
                              is.na(state_1) & is.na(state_2) ~ NA_character_,
                              state_1 == ref ~ "homo_ref",
                              state_1 == alt ~ "homo_alt",
                              TRUE ~ "error"))

#### COMBINE DATA ####
num_loci <-
  genotypes %>%
  mutate(chrom_pos = str_c(chrom,
                           pos,
                           sep="_")) %>%
  pull(chrom_pos) %>%
  unique() %>%
  length()

# heterozygosity by individual
genotypes %>%
  group_by(id,
           genotype) %>%
  summarize(num_pos = n()) %>%
  pivot_wider(names_from = "genotype",
              values_from = "num_pos") %>%
  mutate(heterozygosity_obs_ind = hetero/(hetero + homo_ref + homo_alt),
         pop = case_when(heterozygosity_obs_ind >= het_cutoff_pop3 ~ 3,
                         heterozygosity_obs_ind >= het_cutoff_pop1 ~ 1,
                         TRUE ~ 2)) %>%
  select(id,
         heterozygosity_obs_ind,
         pop) %>%
  ggplot(aes(x=id,
             y=heterozygosity_obs_ind,
             color=pop)) +
  geom_point()

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# heterozygosity by site (There's a problem here, think I fixed it)
# genotypes %>%
#   mutate(chrom_pos = str_c(chrom,
#                            pos,
#                            sep="_")) %>%
#   separate(id,
#            into=(c(NA,
#                    "era",
#                    NA,
#                    NA,
#                    NA,
#                    NA)),
#            remove = FALSE) %>%
#   group_by(chrom,
#            pos,
#            chrom_pos,
#            genotype,
#            era) %>%
#   summarize(num_pos = n()) %>%
#   pivot_wider(names_from = "genotype",
#               values_from = "num_pos") %>% 
#   mutate(across(hetero:homo_alt,
#                 ~replace_na(.,
#                             0)),
#          heterozygosity_obs_locus = hetero/(hetero + homo_ref + homo_alt)) %>%
#   select(chrom,
#          pos,
#          chrom_pos,
#          era,
#          heterozygosity_obs_locus) %>%
#   ggplot(aes(x=chrom_pos,
#              y=heterozygosity_obs_locus,
#              color=era)) +
#   geom_point()

# read in data rather than run the next line of code if rds exists  
# all_data <-
#   readRDS(file = str_c(outDIR,
#                     "/",
#                     outFilePREFIX,
#                     "alldata.rds",
#                     sep=""))

all_data <-
  allele_depths %>%
  # left_join(geno_likes) %>%
  left_join(genotypes) %>%
  left_join(genotypes %>%
              group_by(id,
                       genotype) %>%
              summarize(num_pos = n()) %>%
              pivot_wider(names_from = "genotype",
                          values_from = "num_pos") %>%
              mutate(across(hetero:homo_alt,
                            ~replace_na(.,
                                        0)),
                     heterozygosity_obs_ind = hetero/(num_loci - `NA`),
                     pop = case_when(heterozygosity_obs_ind >= het_cutoff_pop3 ~ 3,
                                     heterozygosity_obs_ind >= het_cutoff_pop1 ~ 1,
                                     TRUE ~ 2)) %>%
              select(id,
                     heterozygosity_obs_ind,
                     pop)) %>%
  separate(id,
           into=(c(NA,
                   "era",
                   NA,
                   NA,
                   NA,
                   NA)),
           remove = FALSE) %>%
  left_join(genotypes %>%
              mutate(chrom_pos = str_c(chrom,
                                       pos,
                                       sep="_")) %>%
              separate(id,
                       into=(c(NA,
                               "era",
                               NA,
                               NA,
                               NA,
                               NA)),
                       remove = FALSE) %>%
              group_by(chrom,
                       pos,
                       chrom_pos,
                       genotype,
                       era) %>%
              summarize(num_pos = n()) %>%
              pivot_wider(names_from = "genotype",
                          values_from = "num_pos") %>% 
              mutate(across(hetero:homo_alt,
                            ~replace_na(.,
                                        0)),
                     heterozygosity_obs_locus = hetero/(hetero + homo_ref + homo_alt)) %>% 
              select(chrom,
                     pos,
                     chrom_pos,
                     era,
                     heterozygosity_obs_locus)) %>%
  mutate(qual = as.double(qual),
         across(contains(c("num_reads",
                           "like",
                           "pos")),
                ~as.numeric(.)),
         num_reads = num_reads_alt + num_reads_ref,
         # genotype = case_when(state_1 != state_2 ~ "hetero",
         #                          is.na(state_1) & is.na(state_2) ~ NA_character_,
         #                          state_1 == ref ~ "homo_ref",
         #                          state_1 == alt ~ "homo_alt",
         #                          TRUE ~ "error"),
         allele_balance = case_when(genotype == "hetero" ~ num_reads_alt / num_reads,
                                    TRUE ~ NA_real_),
         id = str_remove(id,
                         modIdPATTERN),
         chrom_pos = str_c(chrom,
                           pos,
                           sep="_")) 

 saveRDS(all_data, 
         file=str_c(outDIR,
                    "/",
                    outFilePREFIX,
                    "alldata.rds",
                    sep=""))
 
#### SUMMARIZE DATA BY CHROM POS ERA POP ####
all_data <- readRDS("noindels.biallelic.alldata_octoploid.rds")
  all_data_test <- all_data[1:200,1:25]
all_data_diploid <- readRDS("Aen.AB.rad.RAW-6-6.Fltr15.9.recode.alldata.rds")
  all_data_diploid_test <- all_data_diploid[1:200,1:18]
 
#subset octoploid loci list to those that appear in diploid dataset
all_data_subset <- subset(all_data, chrom_pos %in% all_data_diploid$chrom_pos) #missing some sites/individuals (2233705 rows, full diploid set had 6624045)
  all_data_subset_test <- all_data_subset[1:200, 1:26]

#creating column to merge by (chrom-pos-individual ID)
all_data_subset$chrom_pos_id <- paste(all_data_subset$chrom_pos, "_", all_data_subset$id)
all_data_diploid$chrom_pos_id <- paste(all_data_diploid$chrom_pos, "_", all_data_diploid$id)

all_data_merged <- merge(all_data_subset, all_data_diploid, by = "chrom_pos_id")
  all_data_merged_test <- all_data_merged[1:200, 1:44]
all_data_merged_nona <- all_data_merged[(!is.na(all_data_merged$genotype.y)), ] #bc some genotype x (octoploid) called when diploid wasn't --> often bc changed to missing bc read depth too low (<10X)
#left with 1815867 rows

#pull out rows where genotype calls don't match up
#write for loop to ID rows where genotypes do match
match_factor<-c(1:1815867) #length of all_data_merged_nona --> create vector to populate with for loop

for (i in 1:1815867) {
  if (all_data_merged_nona$genotype.x[i] == all_data_merged_nona$genotype.y[i]) {
    match_factor[i] <- "TRUE"
  }
}

#add test_vector of match logic statement to merged dataset
match_factor2 <- c(match_factor)
all_data_merged_nona$matching <- match_factor2
  all_data_merged_test_nona2 <- all_data_merged_nona[1:400, 1:45] #check to make sure for loop worked --> row 274 shouldn't match (it doesn't)
#row numbers don't always match up (just pull out row 274 and triple-check)
  
#pull out rows where genotypes don't match up
genotype_mismatches <- subset(all_data_merged_nona, matching != TRUE) #295936 calls that don't match
  genotype_matches <- subset(all_data_merged_nona, matching == TRUE) #double check get correct number (should be 1815867-295936 = 1519931, yes)

#pull out unique loci that have at least 1 missing call acros all individuals genotyped
genotype_mismatches_chrompos <- unique(sort((genotype_mismatches[, "chrom_pos.x"]))) #12472 matches --> use this to filter green list homo-homo calls against

all_data %>%
   # filter(pop != 3) %>%
   ggplot(aes(x=num_reads,
              y = allele_balance,
              color = era)) +
   geom_point() +
   labs(y = "n heterozygotes") +
   facet_grid(era ~ .,
              scales="free_y")
 
hetero_data_chrom_pos_era <-
  all_data_diploid %>%
  mutate(chrom_pos = str_c(chrom,
                           pos,
                           sep="_")) %>%
  filter(genotype == "hetero") %>% 
  group_by(chrom, 
           pos,
           chrom_pos,
           # pop,
           era) %>%
  summarize(total_num_reads = sum(num_reads),
            total_num_altreads = sum(num_reads_alt),
            total_num_refreads = sum(num_reads_ref),
            mean_read_depth = mean(num_reads),
            mode_read_depth = getMode(num_reads),
            median_read_depth = median(num_reads),
            mode_allele_balance = getMode(allele_balance),
            median_allele_balance = median(allele_balance),
            mean_allele_balance = mean(allele_balance),
            mean_heterozygosity_obs_locus = mean(heterozygosity_obs_locus), #does this really do anything? just one value bc by def calculated across locus
            n = n())

hetero_data_chrom_pos_era$tot_allelebalance <- hetero_data_chrom_pos_era$total_num_altreads/hetero_data_chrom_pos_era$total_num_reads

write.csv(hetero_data_chrom_pos_era, file = "meanAB_data_era_pos.csv")

hetero_data_chrom_pos_era <- read.csv(file = "meanAB_data_era_pos_octoploid.csv", header = TRUE)
 
#perform binomial test to see if have power to know if significantly differentiates from 0.5 AB
res <- t(`colnames<-`(apply(hetero_data_chrom_pos_era, 1, FUN=function(x) {
  rr <- binom.test(as.numeric(x[6]), as.numeric(x[5]), 0.5, "two.sided")
  with(rr, c(x, "2.5%"=conf.int[1], estimate=unname(estimate), 
             "97.5%"=conf.int[2], p.value=unname(p.value)))
}), hetero_data_chrom_pos_era$chrom_pos))

binomialtest_results <- as.data.frame(res)
binomialtest_results$p.value <- as.numeric(as.character(binomialtest_results$p.value))
binomialtest_results$tot_allelebalance <- as.numeric(as.character(binomialtest_results$tot_allelebalance))
bitest_results_alb <- subset(binomialtest_results, binomialtest_results$era == "a")
bitest_results_contemp <- subset(binomialtest_results, binomialtest_results$era == "cbat")

#binomial test results --> probability that we would see ab we see if "real" ab was 0.5 based on power (tot num reads at that locus)
binomialtest_results %>%
  # filter(pop != 3) %>%
  ggplot(aes(x= tot_allelebalance,
             y = p.value,
             color = era)) +
  geom_point() +
  geom_hline(yintercept = 0.05, color = "black") +
  labs(y = "binomial test p-value") +
  facet_grid(era ~ .,
             scales="free_y")

#### AB By Era ####

# all_data %>%
#   ggplot(aes(x=like_hetero)) +
#   geom_histogram() +
#   facet_grid(genotype ~ era)

all_data %>%
  filter(genotype == "hetero") %>%
  ggplot(aes(x=allele_balance,
             fill = era)) +
  geom_histogram(bins=100) +
  geom_vline(xintercept = c(1/8,
                            1/6,
                            2/8,
                            2/6,
                            3/8,
                            4/8,
                            5/8,
                            4/6,
                            6/8,
                            5/6,
                            7/8),
             color="grey",
             linetype="dashed") +
  scale_x_continuous(limits = c(0, 1)) +
  theme_classic() +
  labs(title = "Histograms of Allele Balance",
       subtitle = "Individuals x Position, Most Granular") +
  facet_grid(era ~ .,
             scales = "free")

ggsave(paste(outDIR, 
             outFilePREFIX,
             'HIST-AB-INDxPOS.png', 
             sep = ""), 
       height = 6.5, 
       width = 9)

hetero_data_chrom_pos_era %>% 
  ggplot(aes(x=median_allele_balance,
             fill = era)) +
  geom_histogram(bins=100) +
  geom_vline(xintercept = c(1/8,
                            1/6,
                            2/8,
                            2/6,
                            3/8,
                            4/8,
                            5/8,
                            4/6,
                            6/8,
                            5/6,
                            7/8),
             color="grey",
             linetype="dashed") +
  scale_x_continuous(limits = c(0, 1)) +
  theme_classic() +
  labs(title = "Histograms of Allele Balance",
       subtitle = "Medians by Position") +
  facet_grid(era ~ .,
             scales = "free")

ggsave(paste(outDIR, 
             "/",
             outFilePREFIX,
             'HIST-AB-medPOS.png', 
             sep = ""), 
       height = 6.5, 
       width = 9)

hetero_data_chrom_pos_era %>%
  ggplot(aes(x=mode_allele_balance,
             fill = era)) +
  geom_histogram(bins=100) +
  geom_vline(xintercept = c(1/8,
                            1/6,
                            2/8,
                            2/6,
                            3/8,
                            4/8,
                            5/8,
                            4/6,
                            6/8,
                            5/6,
                            7/8),
             color="grey",
             linetype="dashed") +
  scale_x_continuous(limits = c(0, 1)) +
  theme_classic() +
  labs(title = "Histograms of Allele Balance",
       subtitle = "Modes by Position") +
  facet_grid(era ~ .,
             scales = "free")

ggsave(paste(outDIR, 
             "/",
             outFilePREFIX,
             'HIST-AB-modePOS.png', 
             sep = ""), 
       height = 6.5, 
       width = 9)

#### AB By Num Hets ####

hetero_data_chrom_pos_era %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = n,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "n heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

#mean depth & ab --> taking mean of total num reads & AB/individual at each locus (by era)
hetero_data_chrom_pos_era %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_read_depth,
             y = mean_allele_balance,
             color = era)) +
  geom_point() +
  labs(y = "mean allele balance") +
  facet_grid(era ~ .,
             scales="free_y")

#total depth & ab --> summing up num reads (tot, alt, ref) at each locus (by era) then calculating ab
hetero_data_chrom_pos_era %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=total_num_reads,
             y = tot_allelebalance,
             color = era)) +
  geom_point() +
  labs(y = "total allele balance") +
  facet_grid(era ~ .,
             scales="free_y")

hetero_data_chrom_pos_era %>%
  ggplot(aes(x=mode_allele_balance,
             y = n,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "n heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

hetero_data_chrom_pos_era %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = mean_heterozygosity_obs_locus,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "prop heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

hetero_data_chrom_pos_era %>%
  filter(mean_heterozygosity_obs_locus < 0.6,
         mean_allele_balance > 0.375 & mean_allele_balance < 0.625) %>%
  ggplot(aes(x=mean_allele_balance,
             y = mean_heterozygosity_obs_locus,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "prop heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")


hetero_data_chrom_pos_era %>%
  filter(era != "a",
         mean_heterozygosity_obs_locus < 0.65,
         mean_allele_balance > 0.375 & mean_allele_balance < 0.625) %>%
  ungroup() %>%
  dplyr::select(chrom,
                pos) %>%
  distinct() %>%
  write_tsv(str_c(outDIR, 
                  "/",
                  outFilePREFIX,
                  'chrom_pos_include.tsv', 
                  sep = ""),
            col_names = FALSE)

hetero_data_chrom_pos_era %>%
  filter(era != "a") %>%
  select(chrom,
         pos) %>%
  distinct()

all_data %>%
  mutate(chrom_pos = str_c(chrom,
                           pos,
                           sep="_")) %>%
  filter(genotype != "hetero") %>% 
  # group_by(chrom, 
  #          pos,
  #          chrom_pos,
  #          # pop,
  #          era) %>%
  # summarize(mode_allele_balance = getMode(allele_balance),
  #           median_allele_balance = median(allele_balance),
  #           mean_allele_balance = mean(allele_balance),
  #           mean_heterozygosity_obs_locus = mean(heterozygosity_obs_locus),
  #           n = n())
  filter(era != "a") %>%
  select(chrom,
         pos) %>%
  distinct() %>%
  view()

#### INDIV AB ####

all_data %>%
  filter(genotype == "hetero",
         era == "a") %>%
  mutate(id = str_remove(id,
                         modIdPATTERN)) %>%
  ggplot(aes(x=allele_balance,
             fill = era)) +
  geom_histogram(bins=100) +
  geom_vline(xintercept = c(1/8),
             color="black",
             linetype="solid") +
  scale_x_continuous(limits = c(0, 1)) +
  theme_classic() +
  labs(title = "Histograms of Allele Balance",
       subtitle = "Individuals x Position, Most Granular, Vert Line = 1/8") +
  facet_wrap(era ~ id,
             scales = "free")

ggsave(paste(outDIR, 
             outFilePREFIX,
             'HIST-AB-INDxPOS-ALB.png', 
             sep = ""), 
       height = 9, 
       width = 6.5)


all_data %>%
  filter(genotype == "hetero",
         era != "a") %>%
  mutate(id = str_remove(id,
                         modIdPATTERN)) %>%
  ggplot(aes(x=allele_balance,
             fill = era)) +
  geom_histogram(bins=100) +
  geom_vline(xintercept = c(1/8),
             color="black",
             linetype="solid") +
  scale_x_continuous(limits = c(0, 1)) +
  theme_classic() +
  labs(title = "Histograms of Allele Balance",
       subtitle = "Individuals x Position, Most Granular, Vert Line = 1/8") +
  facet_wrap(era ~ id,
             scales = "free")

ggsave(paste(outDIR, 
             outFilePREFIX,
             'HIST-AB-INDxPOS-CONT.png', 
             sep = ""), 
       height = 9, 
       width = 6.5)

# all_data %>%
#   group_by(id, era) %>%
#   summarize(median_allele_balance = median(allele_balance,
#                                            na.rm = TRUE)) %>%
#   ggplot(aes(x=median_allele_balance,
#              fill = era)) +
#   geom_histogram() +
#   scale_x_continuous(limits = c(0, 1)) +
#   facet_grid(era ~ .,
#              scales = "free")

all_data %>%
  ggplot(aes(x=id,
             y=allele_balance,
             fill=era)) +
  geom_boxplot() +
  geom_hline(yintercept = c(1/8,
                            1/6,
                            1/5,
                            1/4),
             color="black",
             linetype="solid") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust=1)) +
  labs(title = "Boxplots of Allele Balance",
       subtitle = "Individuals x Position, Most Granular, HLines at 1/8, 1/6, 1/5, 1/4",
       x = "Indiviudal ID") 

ggsave(paste(outDIR, 
             outFilePREFIX,
             'BOXPL-AB-INDxPOS.png', 
             sep = ""), 
       height = 6.5, 
       width = 9)

all_data %>%
  ggplot(aes(x=id,
             y=log10(num_reads),
             fill=era)) +
  geom_boxplot() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust=1)) +
  labs(title = "Boxplots of Read Depth",
       subtitle = "Individuals x Position, Most Granular",
       x = "Indiviudal ID") 

ggsave(paste(outDIR, 
             outFilePREFIX,
             'BOXP-DP-INDxPOS.png', 
             sep = ""), 
       height = 9, 
       width = 6.5)

# all_data %>%
#   filter(genotype == "hetero") %>%
#   group_by(id, era) %>%
#   summarize(n_hetero_pos = n()) %>%
#   ggplot(aes(x=id,
#              y=n_hetero_pos,
#              fill = era)) +
#   theme(axis.text.x = element_text(angle = 90, hjust=1)) +
#   geom_col()
# 
# all_data %>%
#   filter(is.na(genotype)) %>%
#   group_by(id, era) %>%
#   summarize(n_missdat_pos = n()) %>%
#   ggplot(aes(x=id,
#              y=n_missdat_pos,
#              fill = era)) +
#   theme(axis.text.x = element_text(angle = 90, hjust=1)) +
#   geom_col()

all_data %>%
  ggplot(aes(x=id,
             fill = genotype)) +
  geom_bar() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust=1)) 


ggsave(paste(outDIR, 
             outFilePREFIX,
             'BARPL-GT-INDxPOS.png', 
             sep = ""), 
       height = 6.5, 
       width = 9)

#######################################################################

######### Filtering to green list of loci ########
#can be run independently from above

hetero_data_chrom_pos_era <- read.csv(file = "meanAB_data_era_pos.csv", header = TRUE)
  hetero_data_chrom_pos_era_test <- hetero_data_chrom_pos_era[1:200, ]

#add columns to cacluate D = "read-ratio deviation" (statistical test for deviation from expected read ratio)
#Based on McKinney et al. 2017
#add SD column (P = 0.5) --> fix this
hetero_data_chrom_pos_era$read_SD <- sqrt(0.5*(1-0.5)*hetero_data_chrom_pos_era$total_num_reads)
#add z-score (for binomial test)
#describes deviation between observed and expected allelic-specific counts from a binomial distribtion (w/ p = q = 0.5)
hetero_data_chrom_pos_era$z_score <- ((hetero_data_chrom_pos_era$total_num_reads/2)-hetero_data_chrom_pos_era$total_num_altreads)/hetero_data_chrom_pos_era$read_SD

#look at z-score distribution
hetero_data_chrom_pos_era %>%
  ggplot(aes(x=z_score,
             y = mean_heterozygosity_obs_locus,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(-25, 25)) +
  labs(y = "n heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

####Filter to list that pass thresholds in both eras (het in both) ####

#filter to "green list" of loci that pass thresholds in contemp individuals
#filter to contemp first
hetero_data_chrom_pos_contemp <- subset(hetero_data_chrom_pos_era, hetero_data_chrom_pos_era$era == "cbat") #33070 starting loci
start_contigs <- sort(unique(as.character(hetero_data_chrom_pos_contemp$chrom))) #3474 starting contigs

#filter to loci w/het <=0.6 (based on McKinney et al. 2017)
hetero_data_chrom_pos_contemp_het0.6 <- subset(hetero_data_chrom_pos_contemp, hetero_data_chrom_pos_contemp$mean_heterozygosity_obs_locus <= 0.60000000) #25969 left

#filter by z_score (btwn -2.5 & 2.5 based on zscore plot and low depth of coverage in Alb) left with 3141
hetero_data_chrom_pos_contemp_het0.6_zscore2.5 <- subset(hetero_data_chrom_pos_contemp_het0.6, hetero_data_chrom_pos_contemp_het0.6$z_score <= 2.5 & hetero_data_chrom_pos_contemp_het0.6$z_score >= -2.5)

#check with scatterplot
contemp_greenlist_plot <- hetero_data_chrom_pos_contemp_het0.6_zscore2.5 %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = n)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "n heterozygotes") #centered on 0.5

#filter to "green list" of loci that pass thresholds in Albatross individuals
#filter to Albatross first
hetero_data_chrom_pos_alb <- subset(hetero_data_chrom_pos_era, hetero_data_chrom_pos_era$era == "a") #36164 starting loci
start_contigs <- sort(unique(as.character(hetero_data_chrom_pos_alb$chrom))) #4169 starting contigs

#filter to loci w/het <=.6
hetero_data_chrom_pos_alb_het0.6 <- subset(hetero_data_chrom_pos_alb, hetero_data_chrom_pos_alb$mean_heterozygosity_obs_locus <= 0.60000000) #29278 left

#filter by z_score (btwn 2.5 & -2.5) left with 5129
hetero_data_chrom_pos_alb_het0.6_zscore2.5 <- subset(hetero_data_chrom_pos_alb_het0.6, hetero_data_chrom_pos_alb_het0.6$z_score <= 2.5 & hetero_data_chrom_pos_alb_het0.6$z_score >= -2.5)

#list of loci that pass filters in both eras
greenlist_hetboth <- as.data.frame(intersect(hetero_data_chrom_pos_contemp_het0.6_zscore2.5$chrom_pos, 
                                             hetero_data_chrom_pos_alb_het0.6_zscore2.5$chrom_pos)) #385 SNPs
  colnames(greenlist_hetboth) <- "chrom_pos"

#### filter for loci that pass thresholds in one era but homozygous in other era ####
#in general, how many loci are het in both eras?
greenlist_hetcontemp_notalb_a <- as.data.frame(setdiff(hetero_data_chrom_pos_contemp$chrom_pos, 
                                                       hetero_data_chrom_pos_alb$chrom_pos))
greenlist_hetalb_notcontemp_a <- as.data.frame(setdiff(hetero_data_chrom_pos_alb$chrom_pos, 
                                                       hetero_data_chrom_pos_contemp$chrom_pos))
  
#want loci that appear in contemp green list but are NOT het in albatross (aren't in hetero_data_chrom_pos_alb)
greenlist_hetcontemp_notalb <- as.data.frame(setdiff(hetero_data_chrom_pos_contemp_het0.6_zscore2.5$chrom_pos, 
                                                     hetero_data_chrom_pos_alb$chrom_pos)) #1933 loci
  colnames(greenlist_hetcontemp_notalb) <- "chrom_pos"

#want loci that appear in albatross green list but are NOT het in contemp (aren't in hetero_data_chrom_pos_contemp)
greenlist_hetalb_notcontemp <- as.data.frame(setdiff(hetero_data_chrom_pos_alb_het0.6_zscore2.5$chrom_pos, 
                                                     hetero_data_chrom_pos_contemp$chrom_pos)) #3401 loci
  colnames(greenlist_hetalb_notcontemp) <- "chrom_pos"

#### filter for loci that are homozygous ref in one era but alt in other era ####
#theoretically any loci that are in homozygous list and not in het list (full one across era) should fall into this

#list of all loci
all_loci_list <- as.data.frame(sort(unique(as.character(all_data_diploid$chrom_pos)))) #47655
  colnames(all_loci_list) <- "chrom_pos"

#list of only loci that have at least one heterozygote
het_loci_list <- as.data.frame(sort(unique(as.character(hetero_data_chrom_pos_era$chrom_pos)))) #42960
  colnames(het_loci_list) <- "chrom_pos"

#loci that don't have any het at all (either era)
#technically could get loci that are fixed in individuals (homo ref & homo alt in contemp, for example), but feel like this should be rare? Also if is case, less likely to have ploidy issues? Not seeing weird allele balance...
greenlist_homo_only <- as.data.frame(setdiff(all_loci_list$chrom_pos, het_loci_list$chrom_pos)) #4695 loci
  colnames(greenlist_homo_only) <- "chrom_pos"

#check mismatch genotype list against greenlist of homo-homo loci from diploid data
#these ones didn't go through filter for diploidy at all (het/AB filters)
#want to make sure not changing calls to hetero if called assuming octoploidy --> any that change calls at even one indv are thrown out
#NOTE: some of these loci may not have shown up in octoploid calling --> not much can do about that? just move forward assuming about as good as we can do?
  #mismatch list created earlier
genotype_mismatches_chrompos_df <- as.data.frame(genotype_mismatches_chrompos)
  colnames(genotype_mismatches_chrompos_df) <- "chrom_bp"

#create list of mismatched sites that originally were "greenlisted"
greenlist_homo_only_match <- as.data.frame(setdiff(greenlist_homo_only$chrom_pos, 
                                                          genotype_mismatches_chrompos_df$chrom_bp)) #of 4695 on list, 3532 did not change genotypes at any indv when genotyping as octoploid (1163 had at least one change)
  colnames(greenlist_homo_only_match) <- "chrom_pos"

#check homozygous calls
homo_only_genotypes <- all_data_diploid[all_data_diploid$chrom_pos %in% 
                                                   greenlist_homo_only_match$chrom_pos, ]
  homo_only_test <- homo_only_genotypes[1:139, ]

#write out just homozygous calls
greenlist_homo_only_split <- greenlist_homo_only_match %>% separate(chrom_pos, into = c("dDocent", "Contig", "contig_num", "pos"),
                                                                    sep = "_", remove = FALSE)
greenlist_homo_only_split$contig <- paste(greenlist_homo_only_split$dDocent, greenlist_homo_only_split$Contig,
                                          greenlist_homo_only_split$contig_num, sep = "_")
greenlist_homo_only_toprint <- greenlist_homo_only_split[, c("contig", "pos")]

write.table(greenlist_homo_only_toprint, file = "greenlist_loci_homo_only.txt", col.names = FALSE, row.names = FALSE, 
            quote = FALSE, sep = "\t")

greenlist_homo_only_toprint <- read.table("greenlist_loci_homo_only.txt")
  colnames(greenlist_homo_only_toprint) <- c("contig", "pos")

#merge all greenlists into one
greenlist_full <- as.data.frame(rbind(greenlist_hetboth, greenlist_hetcontemp_notalb, 
                                      greenlist_hetalb_notcontemp)) #5719
  greenlist_full_sorted <- as.data.frame(sort(unique(as.character(greenlist_full$chrom_pos)))) #5719
  colnames(greenlist_full_sorted) <- "chrom_pos"
  
greenlist_full_split <- greenlist_full_sorted %>% separate(chrom_pos, into = c("dDocent", "Contig", "contig_num", "pos"), 
         sep = "_", remove = FALSE)
greenlist_full_split$contig <- paste(greenlist_full_split$dDocent, greenlist_full_split$Contig, 
                                     greenlist_full_split$contig_num, sep = "_")

greenlist_toprint <- greenlist_full_split[, c("contig", "pos")]

greenlist_toprint2 <- rbind(greenlist_toprint, greenlist_homo_only_toprint) #9251

#how many contigs represented?
greenlist_full_contigs <- sort(unique(as.character(greenlist_toprint2$contig))) #2929 (roughly 3 SNPs/contig)
  
#write out list without header
write.table(greenlist_toprint2, file = "greenlist_loci_full_HD_2.5.txt", col.names = FALSE, row.names = FALSE, 
              quote = FALSE, sep = "\t") #ended with 9251 loci

#compare two greenlists together
greenlist_loci_full_original <- read.csv("greenlist_loci_full.txt", header = FALSE, sep = "\t")
  colnames(greenlist_loci_full_original) <- c("contig", "pos")
  greenlist_loci_full_original$contig_bp <- paste(greenlist_loci_full_original$contig, greenlist_loci_full_original$pos, 
                                             sep = "_")  
  
greenlist_toprint2$contig_bp <- paste(greenlist_toprint2$contig, greenlist_toprint2$pos, 
                                                  sep = "_")  

#loci that pass AB filter but not zscore
greenlist_ABnozscore <- as.data.frame(setdiff(greenlist_toprint2$contig_bp, 
                                                   greenlist_loci_full_original$contig_bp)) #of 4695 on list, 3532 did not change genotypes at any indv when genotyping as octoploid (1163 had at least one change)
  colnames(greenlist_ABnozscore) <- "contig_pos" #5662 that pass all filters

#compare contigs in two greenlists
greenlist_HD_contigs <- as.data.frame(sort(unique(as.character(greenlist_toprint2$contig))))
  colnames(greenlist_HD_contigs) <- "contigs"

greenlist_original_contigs <- as.data.frame(sort(unique(as.character(greenlist_loci_full_original$contig))))
  colnames(greenlist_original_contigs) <- "contigs"

greenlist_contigs_match <- as.data.frame(setdiff(greenlist_original_contigs$contigs, 
                                                     greenlist_HD_contigs$contigs)) #of 2524 in original list, 28 were not found in HD list (~1000 in HD list not in original list)
  
#create HDplot of greenlist loci for albatross & contemp to see how well all fit diploid assumptions

Alb_Contemp_greenlist <- hetero_data_chrom_pos_era[hetero_data_chrom_pos_era$chrom_pos %in% 
                                                     greenlist_full_split$chrom_pos, ] #6104 rows --> not including ones that are homozygous in both eras

#visualize HDplot
greenlist_plot <- Alb_Contemp_greenlist %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = n,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "num heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

#compare mean_allele_balance to binomial test results --> statistically tests do the allele balances significantly differ from 0.5 at margins
binomialtest_results$mean_allele_balance <- as.numeric(as.character(binomialtest_results$mean_allele_balance))
binomial_testresults_greenlist <- binomialtest_results[binomialtest_results$chrom_pos %in% 
                                                     greenlist_contigbp$chrom_pos, ] #3965 rows, check

#visualize binomial test results
binomial_testresults_greenlist_plot <- binomial_testresults_greenlist %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = p.value,
             color = era)) +
  geom_point() +
  geom_hline(yintercept = 0.05, color = "black") + 
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "binomial test p-value") +
  facet_grid(era ~ .,
             scales="free_y")

#total depth & ab --> summing up num reads (tot, alt, ref) at each locus (by era) then calculating ab
Alb_Contemp_greenlist %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = total_num_reads,
             color = era)) +
  geom_point() +
  labs(y = "total number of reads") +
  facet_grid(era ~ .,
             scales="free_y")

#######################################################################

#check mismatch genotype list against greenlist of loci from diploid data
greenlist_diploid <- read.table("greenlist_loci_full.txt", col.names = c("chrom", "bp"))
  greenlist_diploid$chrom_bp <- paste(greenlist_diploid$chrom, greenlist_diploid$bp, sep = "_")

genotype_mismatches_chrompos_df <- as.data.frame(genotype_mismatches_chrompos)
  colnames(genotype_mismatches_chrompos_df) <- "chrom_bp"

greenlist_mismatched <- subset(greenlist_diploid, greenlist_diploid$chrom_bp %in% 
                                 genotype_mismatches_chrompos_df$chrom_bp) #of 8375 that passed filter, 1944 had genotype that changed when genotyping as octoploid

greenlist_mismatchedreal <- as.data.frame(setdiff(greenlist_$chrom_pos, 
                                                          hetero_data_chrom_pos_alb_octo$chrom_pos)) #2437 loci
colnames(greenlist_hetcontemp_notalb_octo) <- "chrom_pos"


hetero_data_chrom_pos_era <- read.csv(file = "meanAB_data_era_pos.csv", header = TRUE)
  greenlist_mismatched_alldata <- subset(hetero_data_chrom_pos_era, hetero_data_chrom_pos_era$chrom_pos %in%
                                           greenlist_mismatched$chrom_bp)
  
#visualize HDplot
greenlist_mismatched_plot <- greenlist_mismatched_alldata %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = n,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "num heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

#can be run independently from above
#for OCTOPLOID data

hetero_data_chrom_pos_era_octo <- read.csv(file = "meanAB_data_era_pos_octoploid.csv", header = TRUE)

#filter to "green list" of loci that pass thresholds in contemp individuals
#filter to contemp first
hetero_data_chrom_pos_contemp_octo <- subset(hetero_data_chrom_pos_era_octo, hetero_data_chrom_pos_era_octo$era == "cbat") #48542 starting loci
start_contigs <- sort(unique(as.character(hetero_data_chrom_pos_contemp_octo$chrom))) #2861 starting contigs

#filter to loci w/het <=0.6
hetero_data_chrom_pos_contemp_octo_het0.6 <- subset(hetero_data_chrom_pos_contemp_octo, hetero_data_chrom_pos_contemp_octo$mean_heterozygosity_obs_locus <= 0.60000000)

#filter by mean AB >= 0.375, <= 0.625 (left with 5280 loci)
hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5 <- subset(hetero_data_chrom_pos_contemp_octo_het0.6, hetero_data_chrom_pos_contemp_octo_het0.6$mean_allele_balance >= 0.37500000 & hetero_data_chrom_pos_contemp_octo_het0.6$mean_allele_balance <= 0.62500000)
hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5_RD10 <- hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5[!(hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5$total_num_reads < 10 & hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5$n == 1), ] #bc never did RD before -- should do this above at all data level (by individual genotype)

#check with scatterplot
contemp_greenlist_plot <- hetero_data_chrom_pos_contemp_het0.5_AB0.5 %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = n)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "n heterozygotes") #skews slightly to left (lower mean values) BUT looks right

#filter to "green list" of loci that pass thresholds in Albatross individuals
#filter to Albatross first
hetero_data_chrom_pos_alb_octo <- subset(hetero_data_chrom_pos_era_octo, hetero_data_chrom_pos_era_octo$era == "a") #42757 starting loci
start_contigs <- sort(unique(as.character(hetero_data_chrom_pos_alb_octo$chrom))) #2825 starting contigs

#filter to loci w/het <=.6
hetero_data_chrom_pos_alb_octo_het0.6 <- subset(hetero_data_chrom_pos_alb_octo, hetero_data_chrom_pos_alb_octo$mean_heterozygosity_obs_locus <= 0.60000000) #29278 left

#filter by mean AB >= 0.375, <= 0.625 (left with 4991 loci)
hetero_data_chrom_pos_alb_octo_het0.6_AB0.5 <- subset(hetero_data_chrom_pos_alb_octo_het0.6, hetero_data_chrom_pos_alb_octo_het0.6$mean_allele_balance >= 0.37500000 & hetero_data_chrom_pos_alb_octo_het0.6$mean_allele_balance <= 0.62500000) #4338
hetero_data_chrom_pos_alb_octo_het0.6_AB0.5_RD10 <- hetero_data_chrom_pos_alb_octo_het0.6_AB0.5[!(hetero_data_chrom_pos_alb_octo_het0.6_AB0.5$total_num_reads < 10 & hetero_data_chrom_pos_alb_octo_het0.6_AB0.5$n == 1), ] #bc never did RD before -- should do this above at all data level (by individual genotype)

#list of loci that pass filters in both eras
greenlist_hetboth_octo <- as.data.frame(intersect(hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5$chrom_pos, 
                                             hetero_data_chrom_pos_alb_octo_het0.6_AB0.5$chrom_pos)) #1006 SNPs --> higher than diploid but makes sense (more likely to have heterozygous loci to begin with - with 8 copies, more rare that all will be one allele)
colnames(greenlist_hetboth_octo) <- "chrom_pos"

#### filter for loci that pass thresholds in one era but homozygous in other era ####
all_data <- readRDS("noindels.biallelic.minQ20.minmeanDP10.nomonomorphic.maxmiss25.maxmissindv75.alldata_octoploid.rds")
all_data_test <- all_data[1:200, 1:18] #subest all_data to something can open up and look at

#want loci that appear in contemp green list but are NOT het in albatross (aren't in hetero_data_chrom_pos_alb)
greenlist_hetcontemp_notalb_octo <- as.data.frame(setdiff(hetero_data_chrom_pos_contemp_octo_het0.6_AB0.5$chrom_pos, 
                                                     hetero_data_chrom_pos_alb_octo$chrom_pos)) #2437 loci
colnames(greenlist_hetcontemp_notalb_octo) <- "chrom_pos"

#want loci that appear in albatross green list but are NOT het in contemp (aren't in hetero_data_chrom_pos_contemp)
greenlist_hetalb_notcontemp_octo <- as.data.frame(setdiff(hetero_data_chrom_pos_alb_octo_het0.6_AB0.5$chrom_pos, 
                                                     hetero_data_chrom_pos_contemp_octo$chrom_pos)) #944 loci
colnames(greenlist_hetalb_notcontemp_octo) <- "chrom_pos"

#### filter for loci that are homozygous ref in one era but alt in other era ####
#theoretically any loci that are in homozygous list and not in het list (full one across era) should fall into this

#list of all loci
all_loci_list <- as.data.frame(sort(unique(as.character(all_data$chrom_pos)))) #53749
colnames(all_loci_list) <- "chrom_pos"

#list of only loci that have at least one heterozygote
het_loci_list <- as.data.frame(sort(unique(as.character(hetero_data_chrom_pos_era_octo$chrom_pos)))) #42960
colnames(het_loci_list) <- "chrom_pos"

#loci that don't have any het at all (either era)
#technically could get loci that are fixed in individuals (homo ref & homo alt in contemp, for example), but feel like this should be rare? Also if is case, less likely to have ploidy issues? Not seeing weird allele balance...
greenlist_homo_only_octo <- as.data.frame(setdiff(all_loci_list$chrom_pos, het_loci_list$chrom_pos)) #1386 loci --> less than with diploid data BUT makes sense (less likely to be homozygous across all chromosome copies)
colnames(greenlist_homo_only_octo) <- "chrom_pos"

#merge all greenlists into one
greenlist_full_octo <- as.data.frame(rbind(greenlist_hetboth_octo, greenlist_hetcontemp_notalb_octo, 
                                      greenlist_hetalb_notcontemp_octo, greenlist_homo_only_octo)) #5773
greenlist_full_sorted_octo <- as.data.frame(sort(unique(as.character(greenlist_full_octo$chrom_pos)))) #5773
colnames(greenlist_full_sorted_octo) <- "chrom_pos"

Alb_Contemp_greenlist_octo <- hetero_data_chrom_pos_era_octo[hetero_data_chrom_pos_era_octo$chrom_pos %in% 
                                                     greenlist_full_sorted_octo$chrom_pos, ] #5393 rows --> not including ones that are homozygous in both eras (not adding up properly?)

#visualize HDplot
greenlist_plot <- Alb_Contemp_greenlist_octo %>%
  # filter(pop != 3) %>%
  ggplot(aes(x=mean_allele_balance,
             y = n,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "num heterozygotes") +
  facet_grid(era ~ .,
             scales="free_y")

##########################################################

#check out read depth for loci pass filter
#read in greenlist
greenlist_HD <- read.table("greenlist_loci_full_HD_2.5.txt", col.names = c("chrom", "bp"))
  greenlist_HD$chrom_pos <- paste(greenlist_HD$chrom, greenlist_HD$bp, sep = "_")
  greenlist_toprint2$chrom_pos <- paste(greenlist_toprint2$contig, greenlist_toprint2$pos, sep = "_")

#subset het_data to list of loci that are on greenlist
het_greenlist <- hetero_data_chrom_pos_era[hetero_data_chrom_pos_era$chrom_pos %in% 
                                                       greenlist_toprint2$chrom_pos, ] #subset to 16515 bc there are some homozygote loci that aren't included in het_greenlist

#subset het_greenlist to list of loci with n het = 1
het_greenlist_nhet1 <- subset(het_greenlist, het_greenlist$n == 1) #9494

#subset het_greenlist_nhet1 to ones that only occur in one era (aren't in greenlist both)
het_greenlist_nhet1_era <- subset(het_greenlist_nhet1, !(het_greenlist_nhet1$chrom_pos %in% 
                                                           greenlist_hetboth$chrom_pos))

#subset to ones that do appear in both eras
het_greenlist_both <- het_greenlist[het_greenlist$chrom_pos %in% 
                                      greenlist_hetboth$chrom_pos, ]

#subset het_greenlist_nhet1_era to ones only appearing in albatross
het_greenlist_nhet1_alb <- subset(het_greenlist_nhet1_era, het_greenlist_nhet1_era$era == "a") #4268

het_greenlist_nhet1_alb_z2.5 <- subset(het_greenlist_nhet1_alb, het_greenlist_nhet1_alb$z_score_orig < 2.5 & het_greenlist_nhet1_alb$z_score_orig > -2.5) #2250

het_greenlist_nhet1_alb_AB0.5 <- subset(het_greenlist_nhet1_alb, het_greenlist_nhet1_alb$mean_allele_balance < 0.75 & het_greenlist_nhet1_alb$mean_allele_balance > 0.25)

#subset het_data_greenlist to everything else
het_greenlist_else <- subset(het_greenlist, het_greenlist$n != 1) #7021

#visualize HDplot
nhet1_era_plot <- het_greenlist_nhet1_era %>%
  # filter(pop != 3) %>%
  ggplot(aes(x = mean_allele_balance,
             y = mean_read_depth,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "read depth") +
  facet_grid(era ~ .,
             scales="free_y")

else_plot <- het_greenlist_both %>%
  # filter(pop != 3) %>%
  ggplot(aes(x= mean_allele_balance,
             y = mean_read_depth,
             color = era)) +
  geom_point() +
  scale_x_continuous(limits = c(0, 1)) +
  labs(y = "read depth") +
  facet_grid(era ~ .,
             scales="free_y")

#looking at depth by individual for ones with low depth & nhet = 1
lowdepth_test <- subset(all_data_diploid, all_data_diploid$chrom_pos == "dDocent_Contig_10976_87" & 
                          all_data_diploid$genotype == "hetero")
lowdepth_indv <- subset(all_data_diploid, all_data_diploid$id == "aen_a_ham_019")
lowdepth_site <- subset(all_data_diploid, all_data_diploid$chrom_pos == "dDocent_Contig_10135_76")

#plot depth at individual across all sites
lowdepth_indv %>%
  ggplot(aes(x = allele_balance,
             y = num_reads)) + 
  geom_point() + 
  scale_x_continuous(limits = c(0,1))

#plot depth at site across all individuals
lowdepth_site %>%
  ggplot(aes(x = id,
             y = num_reads,
             color = era)) + 
  geom_point() + 
  facet_grid(era ~ .)

#look at loci that pass greenlist for contemp relative to alb zscore
het_greenlist_both_contemp_test <- hetero_data_chrom_pos_era[hetero_data_chrom_pos_era$chrom_pos %in% 
                                      hetero_data_chrom_pos_contemp_het0.6_zscore2.5$chrom_pos, ] #4349 lines
  #1933 of these are het only in contemp
  #means 823 sites that are het in both but only pass filter in contemp  (4349-1933 = 2416/2 = 1208 - 385 = 823) -- bc 385 that pass in both eras
  #AND 3141 sites overall that pass filter in contemp -- either pass filter in both, pass filter only in contemp but found in both, or pass filter and only found in contemp

#look at loci that pass greenlist for alb relative to contemp zscore
het_greenlist_both_alb_test <- hetero_data_chrom_pos_era[hetero_data_chrom_pos_era$chrom_pos %in% 
                                                       hetero_data_chrom_pos_alb_het0.6_zscore2.5$chrom_pos, ] #6857 lines
  #3401 of these het only in alb
  #means 1343 sites that are het in both but only pass filter in alb
  #and 5129 sites overall that pass filter in alb
  #so of 26274 sites that are het in both, 385 pass filters in both, and 2166 pass filters in only one of two eras
    #thus, fewer of these pass filters in general?? relative to ones that are fixed in one era and not in other (those have higher proportions -- closer to 30% instead of 10%)

#plot z-score
het_greenlist_both_alb_test %>%
  ggplot(aes(x = mean_allele_balance,
             y = z_score,
             color = era)) + 
  geom_point() + 
  scale_x_continuous(limits = c(0,1)) + 
  facet_grid(era ~ .)

#In general then, probably not losing a lot of loci that are het in both (not skewing data to private alleles as bad?)
  #Bc most of the loci we have that are het in both are likely octoploid, and thus can't evaluate
  #Of course, assumption is that the ones that are diploid are fair representation of rest of genome?

#Last filtering = try keeping loci that pass filter (z-score = 2.5) in at least one era (aka if het in both, don't have to pass filter in both)
#first, bind hetero_data_chrom_pos for each era together
hetero_data_chrom_pos_both_het0.6_zscore2.5 <- rbind(hetero_data_chrom_pos_alb_het0.6_zscore2.5, 
                                                     hetero_data_chrom_pos_contemp_het0.6_zscore2.5)

greenlist_het_either <- as.data.frame(sort(unique(as.character(hetero_data_chrom_pos_both_het0.6_zscore2.5$chrom_pos)))) #7885 --> makes sense (8270-385 (that know are het in both))
colnames(greenlist_het_either) <- "chrom_pos"

#merge with homo only
greenlist_full_sorted <- as.data.frame(sort(unique(as.character(greenlist_het_either$chrom_pos)))) #5719
colnames(greenlist_full_sorted) <- "chrom_pos"

greenlist_full_split <- greenlist_full_sorted %>% separate(chrom_pos, into = c("dDocent", "Contig", "contig_num", "pos"), 
                                                           sep = "_", remove = FALSE)
greenlist_full_split$contig <- paste(greenlist_full_split$dDocent, greenlist_full_split$Contig, 
                                     greenlist_full_split$contig_num, sep = "_")

greenlist_toprint <- greenlist_full_split[, c("contig", "pos")]

greenlist_toprint2 <- rbind(greenlist_toprint, greenlist_homo_only_toprint) #9251

#how many contigs represented?
greenlist_full_contigs <- sort(unique(as.character(greenlist_toprint2$contig))) #3320 (roughly 3 SNPs/contig)

#write out list without header
write.table(greenlist_toprint2, file = "greenlist_loci_full_HDlen.txt", col.names = FALSE, row.names = FALSE, 
            quote = FALSE, sep = "\t") #ended with 11417 loci
