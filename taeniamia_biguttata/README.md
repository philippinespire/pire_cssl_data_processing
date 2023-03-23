# Tbi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Taeniamia biguttata* samples.

---

Information on data pre-processing steps (up to step 14 and 7 respectively) can be found in the READMEs for the 1st sequencing run and 2nd sequencing run directories.

---
## Merging .bam files from two separate runs

Used script Brendan created to merge. However the bash and sbatch script was copied to spp's directory in order to maintain consistency with naming (ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate).

```sh 
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/ Ssp
```

Add unmerged bam files from the sequencing runs into new directory. 

```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/copyunmerged.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/ mergebams_run1run2/ mkBAMmerge
```

Needed to run `merge_fixrg_array` for the merged .bam files to interpreted correctly. Again, the sbatch and bash script was copied and added to spp's directory so it can be edited so that that the file names are correct.

```sh
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/merge_fixrg_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAMmerge/ #I had to run this twice since it didn't seem to do all indivudals the first time.
```

---

## Make and filter VCF for merged BAM files

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAMmerge/
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.6.lcwgs 
```

Make a filtering directory

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAMmerge/
mkdir /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/filterVCF_merge
```

Since the code is being worked with while in Eric's directory, no need to clone. However, if not, clone the fltrVCF and rad_haplotyper repos and copy config.fltr.ind.cssl over to filterVCF_merge.

Copy config file to directory

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/filterVCF_merge
cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Update config with correct paths

```sh
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07                                    # order to run filters in
        fltrVCF -c ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate                                 # cutoffs, ie ref description
        fltrVCF -b ../mkBAMmerge                                                                            # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                                            # path to fltrVCF R scripts
        fltrVCF -d ../mkBAMmerge/mapped.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate.bed        # bed file used in genotyping
        fltrVCF -v ../mkBAMmerge/TotalRawSNPs.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate.vcf  # vcf file to filter
        fltrVCF -g ../mkBAMmerge/reference.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate.fasta   # reference genome
        fltrVCF -p ../mkBAMmerge/popmap.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate            # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                                           # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                                           # path to rad_haplotyper scri
        fltrVCF -o Tbi.A                                                                                    # prefix on output files, use
        fltrVCF -t 40                                                                                       # number of threads [1]
```
Filter 5 was changed from 0:55:0.6 to 0.8.
