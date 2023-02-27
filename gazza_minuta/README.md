# Gmi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Gazza minuta* samples from Hamilo Cove.

---

Information on data pre-processing steps (up to step 14 and 7 respectively) can be found in the READMEs for the 1st sequencing run and 2nd sequencing run directories.

---
## Merging .bam files from two separate runs (12/15/22)

Used the following command:

```
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta Gmi
```

Output: merged.bam files in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mergebams_run1run2

Fix read group information in merged .bam files.

```
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge_copy
```

---
## Filter and make VCF for merged BAM files

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch fltrBAM config.5.cssl #Run filtering
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.5.cssl #Make VCF files
```

---
## Filter VCF files

Make a filtering directory

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta
mkdir /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
```

Since the code is being worked with while in Eric's directory, no need to clone. However, if not, clone the fltrVCF and rad_haplotyper repos and copy config.fltr.ind.cssl over to filterVCF_merge.

Copy config file to directory

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Update config with correct paths

```
fltrVCF Settings, run fltrVCF -h for description of settings
         # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07               # order to run filters in
        fltrVCF -c ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off                         # cutoffs, ie ref description
        fltrVCF -b ../mkBAMmerge                                                       # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                       # path to fltrVCF R scripts
        fltrVCF -d ../mkBAMmerge/mapped.rad.RAW-10-10.bed                              # bed file used in genotyping
        fltrVCF -v ../mkBAMmerge/TotalRawSNPs.rad.RAW-10-10.vcf                        # vcf file to filter
        fltrVCF -g ../mkBAMmerge/reference.rad.RAW-10-10.fasta                         # reference genome
        fltrVCF -p ../mkBAMmerge/popmap.rad.RAW-10-10                                  # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                      # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                      # path to rad_haplotyper script
        fltrVCF -o Gmi.A                                                               # prefix on output files, use to track settings
        fltrVCF -t 40                                                                  # number of threads [1]
        fltrVCF -o Gmi.A 
```
The filter settings didn't need adjustment and were were left at the default.

Run fltrVCF.sbatch

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl
```

---
## Check for cryptic species

Make a population_structure directory and copy your filtered VCF file there.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge

mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCF/Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.18.vcf .

#There were too many "_" in sample ID names. This was rectified manually by editing the VCF using nano as there was issues with bcftools reading the VCF file.
```

Run PCA using PLINK. Instructions for installing Plink with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure
#create your conda popgen environment and install PLINK

module load anaconda
conda activate popgen

#VCF file has split chromosome, so running PCA from bed file
plink --vcf Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.18.vcf --alow-extra-chr --make-bed --out PIRE.Gmi.Bas.preHWE
plink --pca --allow-extra-chr --bfile PIRE.Gmi.Bas.preHWE --out PIRE.Gmi.Bas.preHWE

conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

#bed and bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Gmi.Bas.preHWE.bim > PIRE.Gmi.Bas.preHWE.bim.tmp
mv PIRE.Gmi.Bas.preHWE.bim.tmp PIRE.Gmi.Bas.preHWE.bim

conda deactivate
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Gmi.Bas.preHWE.bed 1 --cv > PIRE.Gmi.Bas.preHWE.log1.out #run from 1-5

conda deactivate
```

Copied `*.eigenval`, `*.eigenvec`, & `*.Q` files to local computer. Ran pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R on local computer to visualize PCA & ADMIXTURE results (figures in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/pop_structure).

---
## Filter VCF file for HWE

PCA & ADMIXTURE showed cryptic structure. Most samples were assigned group "A" and the remaining were group "B".
Adjusted popmap file to reflect new structure.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/filterVCF
cp ../mkBAM/popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate  ./popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.HWEsplit

#added -A or -B to end of pop assignment (second column) to assign individual to either group A or group B.
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/filterVCF
cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.HWE
```
