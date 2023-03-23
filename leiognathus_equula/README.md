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

## Make and filter VCF for merged BAM files

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/mkBAMmerge/
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.6.rad 
```

Make a filtering directory

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/mkBAMmerge/
mkdir /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/filterVCF_merge
```

Since the code is being worked with while in Eric's directory, no need to clone. However, if not, clone the fltrVCF and rad_haplotyper repos and copy config.fltr.ind.cssl over to filterVCF_merge.

Copy config file to directory

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/filterVCF_merge
cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Update config with correct paths

```sh
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07                     # order to run filters in
        fltrVCF -c rad.RAW-2-2                                                               # cutoffs, ie ref description
        fltrVCF -b ../mkBAMmerge                                                             # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
        fltrVCF -d ../mkBAMmerge/mapped.rad.RAW-2-2.bed                                      # bed file used in genotyping
        fltrVCF -v ../mkBAMmerge/TotalRawSNPs.rad.RAW-2-2.vcf                                # vcf file to filter
        fltrVCF -g ../mkBAMmerge/reference.rad.RAW-2-2.fasta                                 # reference genome
        fltrVCF -p ../mkBAMmerge/popmap.rad.RAW-2-2                                          # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Leq.A                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```
The filter settings didn't need adjustment and were left at the default.

Run fltrVCF.sbatch

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/filterVCF_merge
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl 
```

---

## Check for cryptic species

Make a population_structure directory and copy your filtered VCF file there.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/filterVCF_merge

mkdir pop_structuremerge
cd ../pop_structuremerge

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCFmerge/Leq.A.rad.RAW-2-2.Fltr07.18.vcf .

#There were too many "_" in sample ID names. This was rectified manually by editing the VCF using nano as there was issues with bcftools reading the VCF file.
```

Run PCA using PLINK. Instructions for installing Plink with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).
```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/pop_structuremerge

#create your conda popgen environment and install PLINK

module load anaconda
conda activate popgen

#VCF file has split chromosome, so running PCA from bed file
plink --vcf Leq.A.rad.RAW-2-2.Fltr07.18.vcf --allow-extra-chr --make-bed --out PIRE.Leq.Bas.preHWE
plink --pca --allow-extra-chr --bfile PIRE.Leq.Bas.preHWE --out PIRE.Leq.Bas.preHWE 

conda deactivate
```

Made input files for ADMIXTURE with PLINK.
```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/pop_structuremerge

module load anaconda
conda activate popgen

#bed and bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Leq.Bas.preHWE.bim > PIRE.Leq.Bas.preHWE.bim.tmp
mv PIRE.Leq.Bas.preHWE.bim.tmp PIRE.Leq.Bas.preHWE.bim

conda deactivate
```

Run ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/pop_structuremerge

module load anaconda
conda activate popgen

admixture admixture PIRE.Leq.Bas.preHWE.bed 1 --cv > PIRE.Leq.Bas.preHWE.log1.out #run from 1-5

conda deactivate
```

Copied `*.eigenval`, `*.eigenvec`, & `*.Q` files to local computer. Ran pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R on local computer to visualize PCA & ADMIXTURE results (figures in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/pop_structuremerge).

--- 

## Filter VCF file for HWE
**NOTE:** If PCA & ADMIXTURE results don't show cryptic structure, skip to running `fltrVCF.sbatch`.

No evidence for cryptic species. Proceeded to next step.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/filterVCF_merge

```
