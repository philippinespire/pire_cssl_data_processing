# Tbi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Taeniamia biguttata* samples.

---

Information on data pre-processing steps (up to step 14 and 7 respectively) can be found in the READMEs for the 1st sequencing run and 2nd sequencing run directories.

---
## Merging .bam files from two separate runs

Used script Brendan created to merge. However the bash and sbatch script was copied to spp's directory in order to maintain consistency with naming (ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate).

```sh 
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/ Tbi
```

Add unmerged bam files from the sequencing runs into new directory. 

```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/copyunmerged.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/ mergebams_run1run2/ mkBAMmerge
```

Needed to run `merge_fixrg_array` for the merged .bam files to interpreted correctly. Again, the sbatch and bash script was copied and added to spp's directory so it can be edited so that that the file names are correct.

```sh
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/merge_fixrg_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAMmerge/ #I had to run this multiple times since it didn't seem to do all indivudals after a single run
```

---

## Make and filter VCF for merged BAM files

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAMmerge/
sbatch /home/e1garcia/shotgun_PIRE/dDocentHPC/dDocentHPC.sbatch mkVCF config.6.cssl
```
However, the final VCF file had the error "Chromosome blocks not continuous." Tried to amend this using the resort command but it did not work.
