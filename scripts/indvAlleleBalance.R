


#### Initialize ####
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(magrittr)
library(janitor)

#### Set Variables ####
alleledepthFILE = '../leiognathus_leuciscus/filterVCF/lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.100.AD.tsv'
# genolikelihoodFILE = 'leiognathus_leuciscus/filterVCF/lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.100.GL.tsv'
genoFILE = '../leiognathus_leuciscus/filterVCF/lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.100.GT.tsv'

alleledepthFILE = '../atherinomorus_endrachtensis/filterVCF_ceb/Aen.A3.rad.RAW-6-6.Fltr15.9.recode.AD.tsv'
genoFILE = '../atherinomorus_endrachtensis/filterVCF_ceb/Aen.A3.rad.RAW-6-6.Fltr15.9.recode.GT.tsv'


#### READ in DATA ####
allele_depths <-
  read_tsv(alleledepthFILE,
           col_types=cols(.default = "c")) %>%
  clean_names() %>%
  pivot_longer(cols=contains("lle_"),
               names_to="id") %>%
  separate(col=value,
           into=(c("num_reads_ref",
                  "num_reads_alt")),
           convert=TRUE)

# geno_likes <-
#   read_tsv(genolikelihoodFILE,
#            col_types=cols(.default = "c")) %>%
#   clean_names() %>%
#   pivot_longer(cols=contains("lle_"),
#                names_to="id") %>%
#   separate(col=value,
#            into=(c("like_homo_ref",
#                    "like_hetero",
#                    "like_homo_alt")),
#            convert=TRUE)

genotypes <-
  read_tsv(genoFILE,
           col_types=cols(.default = "c")) %>%
  clean_names() %>%
  pivot_longer(cols=contains("lle_"),
               names_to="id") %>%
  # mutate(value = str_replace_all(value,
  #                            pattern = "\\.",
  #                            replacement = "NA")) %>%
  separate(col=value,
           into=(c("state_1",
                   "state_2"))) %>%
  mutate(state_1 = na_if(state_1,
                        ""),
         state_2 = na_if(state_2,
                         ""))

#### COMBINE DATA ####
all_data <-
  allele_depths %>%
    # left_join(geno_likes) %>%
    left_join(genotypes) %>%
  mutate(qual = as.double(qual),
         across(contains(c("num_reads",
                           "like",
                           "pos")),
                ~as.numeric(.)),
         num_reads = num_reads_alt + num_reads_ref,
         state_hetero = case_when(state_1 != state_2 ~ "hetero",
                                  is.na(state_1) & is.na(state_2) ~ NA_character_,
                                  state_1 == ref ~ "homo_ref",
                                  TRUE ~ "homo_alt"),
         allele_balance = case_when(state_hetero == "hetero" ~ num_reads_alt / num_reads,
                                    TRUE ~ NA_real_)) %>%
  separate(id,
           into=(c(NA,
                  "era",
                  NA,
                  NA,
                  NA,
                  NA)),
           remove = FALSE)

#### AB By Era ####

# all_data %>%
#   ggplot(aes(x=like_hetero)) +
#   geom_histogram() +
#   facet_grid(state_hetero ~ era)

all_data %>%
  filter(state_hetero == "hetero") %>%
  ggplot(aes(x=allele_balance,
             fill = era)) +
  geom_histogram() +
  facet_grid(era ~ .,
             scales = "free")

all_data %>%
  filter(state_hetero == "hetero") %>%
  group_by(chrom, pos,era) %>%
  summarize(median_allele_balance = median(allele_balance)) %>%
  ggplot(aes(x=median_allele_balance,
             fill = era)) +
  geom_histogram() +
  facet_grid(era ~ .,
             scales = "free")

#### INDIV AB ####

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
  geom_boxplot()

all_data %>%
  ggplot(aes(x=id,
             y=num_reads,
             fill=era)) +
  geom_boxplot()

# all_data %>%
#   filter(state_hetero == "hetero") %>%
#   group_by(id, era) %>%
#   summarize(n_hetero_pos = n()) %>%
#   ggplot(aes(x=id,
#              y=n_hetero_pos,
#              fill = era)) +
#   theme(axis.text.x = element_text(angle = 90, hjust=1)) +
#   geom_col()
# 
# all_data %>%
#   filter(is.na(state_hetero)) %>%
#   group_by(id, era) %>%
#   summarize(n_missdat_pos = n()) %>%
#   ggplot(aes(x=id,
#              y=n_missdat_pos,
#              fill = era)) +
#   theme(axis.text.x = element_text(angle = 90, hjust=1)) +
#   geom_col()

all_data %>%
  ggplot(aes(x=id,
             fill = state_hetero)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust=1)) 
  
