# Leq Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Leiognathus equula* samples.

---

Information on data pre-processing steps (up to step 14 and 7 respectively) can be found in the READMEs for the 1st sequencing run and 2nd sequencing run directories.

---
## Merging .bam files from two separate runs

Used script Brendan created to merge. However the bash and sbatch script was copied to spp's directory in order to maintain consistency with naming (rad.RAW-2-2). 

```sh
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/ Leq
```

Add unmerged bam files from the sequencing runs into new directory. 

```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/copyunmerged.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/ mergebams_run1run2/ mkBAMmerge
```

Needed to run `merge_fixrg_array` for the merged .bam files to interpreted correctly. Again, the sbatch and bash script was copied and added to spp's directory so it can be edited so that that the file names are correct.

```sh
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/merge_fixrg_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/mkBAMmerge/
```

---

## Filter and make VCF for merged BAM files

```sh



