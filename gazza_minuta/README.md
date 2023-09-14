# Gmi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Gazza minuta* samples from Hamilo Cove.

---

Information on data pre-processing steps (up to step 14 and 7 respectively) can be found in the READMEs for the 1st sequencing run and 2nd sequencing run directories.

---
## Merging .bam files from two separate runs (12/15/22)

Used the following command:

```sh
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta Gmi
```

Output: merged.bam files in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mergebams_run1run2

Fix read group information in merged .bam files.

```sh
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge_copy
```

---
## Filter and make VCF for merged BAM files

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch fltrBAM config.5.cssl #Run filtering
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.5.cssl #Make VCF files
```

---
## Filter VCF files

Make a filtering directory

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta
mkdir /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
```

Since the code is being worked with while in Eric's directory, no need to clone. However, if not, clone the fltrVCF and rad_haplotyper repos and copy config.fltr.ind.cssl over to filterVCF_merge.

Copy config file to directory

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Update config with correct paths

```sh
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
The filter settings didn't need adjustment and were left at the default.

Run fltrVCF.sbatch

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl
```

---
## Check for cryptic species

Make a population_structure directory and copy your filtered VCF file there.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge

mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCF/Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.18.vcf .

#There were too many "_" in sample ID names. This was rectified manually by editing the VCF using nano as there was issues with bcftools reading the VCF file.
```

Run PCA using PLINK. Instructions for installing Plink with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
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

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

#bed and bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Gmi.Bas.preHWE.bim > PIRE.Gmi.Bas.preHWE.bim.tmp
mv PIRE.Gmi.Bas.preHWE.bim.tmp PIRE.Gmi.Bas.preHWE.bim

conda deactivate
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Gmi.Bas.preHWE.bed 1 --cv > PIRE.Gmi.Bas.preHWE.log1.out #run from 1-5

conda deactivate
```

Copied `*.eigenval`, `*.eigenvec`, & `*.Q` files to local computer. Ran pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R on local computer to visualize PCA & ADMIXTURE results (figures in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure_merge).

---
## Filter VCF file for HWE

PCA & ADMIXTURE showed cryptic structure. Most samples were assigned group "A" and the remaining were group "B".
Adjusted popmap file to reflect new structure.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
cp ../mkBAMmerge/popmap.rad.RAW-10-10  ./popmap.rad.RAW-10-10.HWEsplit

#added -A or -B to end of pop assignment (second column) to assign individual to either group A or group B.
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge
cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)
```

Make a copy of the `config.fltr.ind.cssl` file called `config.fltr.ind.cssl.HWE` with file paths and file extensions based on your species AND the new HWEsplit popmap (if applicable). The VCF path should point to the VCF made at the end of the previous filtering run (the file PCA & ADMIXTURE was run with). Remove any filters that aren't run in this step (from the `fltrVCF -f` line). **You will only run filters 18 & 17 (in that order).**

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 18 17                                                                     # order to run filters in
        fltrVCF -c ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off                               # cutoffs, ie ref description
        fltrVCF -b ../mkBAMmerge                                                             # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
        fltrVCF -d ../mkBAMmerge/mapped.rad.RAW-10-10.bed                                    # bed file used in genotyping
        fltrVCF -v Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.18.vcf           # vcf file to filter
        fltrVCF -g ../mkBAMmerge/reference.rad.RAW-10-10.fasta                               # reference genome
        fltrVCF -p popmap.rad.RAW-10-10.HWEsplit                                             # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Gmi.A                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```
Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.HWE
```

---
## Make a `VCF` file with monomorphic loci

Create a `mkVCF_monomorphic` dir to make an "all sites" VCF (with monomorphic loci included) and move necessary files over.


```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

mkdir mkVCF_monomorphic

mv mkBAM/*bam* mkVCF_monomorphic
mv mkBAM/*fasta mkVCF_monomorphic
mv mkBAM/config.5.cssl mkVCF_monomorphic/config.5.cssl.monomorphic
```

Change the `config.5.cssl.monomorphic` file so that the last setting (monomorphic) is set to yes.

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles,
```

Genotype with [dDocentHPC_mkVCF.sbatch](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC_mkVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

sbatch ../../halichoeres_miniatus/mkVCF_monomorphic/dDocentHPC.sbatch config.5.cssl.monomorphic 
```

---

## Filter the VCF with monomorphic loci

First, set-up filtering for monomorphic sites only. Copy the `config.fltr.ind.cssl.mono` file over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

cp ../../scripts/config.fltr.ind.cssl.mono .
```

Update the `config.fltr.ind.cssl.mono` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made. **The settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file.**


```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 04 14 05 16 04 13 05 16 17                                                                                      # order to run filters in
        fltrVCF -c rad.RAW-10-10-RG                                                                                                      # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge                                         # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF                                                 # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge/mapped.rad.RAW-10-10.bed                # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/TotalRawSNPs.rad.RAW-10-10.vcf   # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/reference.rad.RAW-10-10.fasta    # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/popmap.rad.RAW-10-10.HWEsplit      # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                        # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                        # path to rad_haplotyper script
        fltrVCF -o Gmi.mono                                                                                                              # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                    # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for monomorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.mono
```

Next, set-up filtering for polymorphic sites only. Make a `polymorphic_filter` directory in `mkVCF_monomorphic` and copy the `config.fltr.ind.cssl.poly` file over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

mkdir polymorphic_filter
cd polymorphic_filter

cp ../../../scripts/config.fltr.ind.cssl.poly .
```

Update the `config.fltr.ind.cssl.poly` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made AND the HWEsplit popmap you made if you had any cryptic population structure. **The settings for all your filters should match the settings used when filtering the original VCF file.**

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07 18 17                                                             # order to run filters in
        fltrVCF -c rad.RAW-10-10-RG                                                                                                        # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic                                    # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                           # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge/mapped.rad.RAW-10-10.bed                  # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/TotalRawSNPs.rad.RAW-10-10.vcf     # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/reference.rad.RAW-10-10.fasta      # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/popmap.rad.RAW-10-10.HWEsplit        # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                          # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                          # path to rad_haplotyper script
        fltrVCF -o Gmi.poly                                                                                                                # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                      # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for polymorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#popmap file should be the one that accounts for any cryptic structure, if it exists (*HWEsplit extension)
#settings should match the settings used when filtering the original VCF file
sbatch ../../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.poly 
```


## Merge monomorphic & polymorphic VCF files

Check the *filtered* monomorphic & polymorphic VCF files to make sure that filtering removed the same individuals. If not, remove the necessary individuals from the relevant files. *Your monomorphic and polymorphic VCFs should have the EXACT same individuals present. If not, merging will not work!*

Next, sort each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load vcftools

vcftools --vcf Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.vcf
vcf-sort Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.vcf > Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf

vcftools --vcf Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.vcf --remove ../indv_missing.txt --recode --recode-INFO-all --out Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.vcf
vcf-sort Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.vcf > Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf
```

Zip each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load samtools/1.9

bgzip -c Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf > Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz
bgzip -c Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf > Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf.gz

```

Index each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load samtools/1.9

tabix Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz
tabix Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Had to re-sort and reheader poly VCF file

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/polymorphic_filter

crun bcftools reheader -h header_poly.txt -o Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf
bgzip -c Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf > Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf.gz

bash
export SINGULARITY_BIND=/home/e1garcia
crun bcftools concat --allow-overlaps Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf.gz -O z -o Gmi.all.recode.sorted.vcf.gz

tabix Gmi.all.recode.nomissing.sorted.vcf.gz

exit
```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

bash
crun bcftools concat --allow-overlaps Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf.gz -O z -o Gmi.all.recode.sorted.vcf.gz
tabix Gmi.all.recode.nomissing.sorted.vcf.gz
exit
```
