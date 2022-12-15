# Gmi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Gazza minuta* samples from Hamilo Cove.

---

Information on data pre-processing steps (up to step 7) can be found in the READMEs for the 1st sequencing run and 2nd sequencing run directories.


## Step 7. Set up mapping dir and get reference genome

Pulled latest changes from dDocentHPC repo & copied `config.5.cssl` over.

```
#if you haven't already, you first need to clone the dDocentHPC.git repo
#cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
#git clone https://github.com/cbirdlab/dDocentHPC.git

cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts/dDocentHPC
git pull

cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta
cp ../scripts/dDocentHPC/configs/config.5.cssl mkBAM
```

Because there is no whole genome reference for *G. minuta*, I am using the full "rwaw" reference fasta from the RAD data used to make probes.

```
#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM/PIRE_GazzaMinuta.C.10.10.probes4development.fasta reference.rad.RAW-10-10.fasta
```

Updated the config file with the ref genome info.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM
nano config.5.cssl
```

Inserted `<assembly type>` into the `Cutoff1` variable and `<unique assembly info>` into the `Cutoff2` variable.

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
rad               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
RAW-10-10               Cutoff2 (integer)
                Use unique reads that occur in at least this many individuals for making the reference genome
0.05    rainbow merge -r <percentile> (decimal 0-1)                                             Percentile-based minimum number of seqs to assemble in a precluster
0.95    rainbow merge -R <percentile> (decimal 0-1)                                             Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------

----------mkBAM: Settings for mapping the reads to the reference genome-------------------------------------------
Make sure the cutoffs above match the reference*fasta!
1               bwa mem -A Mapping_Match_Value (integer)
4               bwa mem -B Mapping_MisMatch_Value (integer)
6               bwa mem -O Mapping_GapOpen_Penalty (integer)
30              bwa mem -T Mapping_Minimum_Alignment_Score (integer)                    Remove reads that have an alignment score less than this.
5       bwa mem -L Mapping_Clipping_Penalty (integer,integer)
------------------------------------------------------------------------------------------------------------------
```

---

## Step 8. Map reads to reference - Filter Maps - Genotype Maps

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../dDocentHPC.sbatch config.5.cssl
```

---

## Step 9. Filter VCF Files

Pulled latest changes from fltrVCF and rad_haplotyper repos

```
#if you haven't already, you first need to clone the fltrVCF.git repo & the rad_haplotyper.git repo
#cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
#git clone https://github.com/cbirdlab/fltrVCF.git
#git clone https://github.com/cbirdlab/rad_haplotyper.git

cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts/fltrVCF
git pull

cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts/rad_haplotyper
git pull

cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta
mkdir filterVCF

cp ../scripts/fltrVCF/config_files/config.fltr.ind.cssl filterVCF
```

Because many *Gazza minuta* contemporary individuals had low numbers of reads, removed individuals with <100K sequences from VCF prior to running `fltrVCF.sbatch`. This removes individuals with the most amount of missing data beforehand, allowing us to retain more sites (losing fewer SNPs due to too much missing data, etc.).

```
#created list of individuals to remove (35 total, all contemporary)

cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF

module load vcftools

vcftools --vcf ../mkBAM/TotalRawSNPs.rad.RAW-10.10.vcf --remove indvfewsequences.txt --recode --recode-INFO-all --out TotalRawSNPs.rad.RAW-10-10.noindvless100Kseq
```

Ran `fltrVCF.sbatch`.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to the second 07 filter (remove filters 18 & 17 from list of filters to run)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl

#troubleshooting will be necessary
```

---

## Step 10. Check for cryptic species

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta
mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCF/*Fltr07.18.vcf .
```

Ran PCA w/PLINK. Instructions for installing PLINK with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

plink --vcf Gmi.A.rad.RAW-10-10.Fltr07.18.vcf --allow-extra-chr --pca --out PIRE.Gmi.Ham.preHWE
conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

plink --vcf Gmi.A.rad.RAW-10-10.Fltr07.18.vcf --allow-extra-chr --make-bed --out PIRE.Gmi.Ham.preHWE

awk '{$1=0;print $0}' PIRE.Gmi.Ham.preHWE.bim > PIRE.Gmi.Ham.preHWE.bim.tmp
mv PIRE.Gmi.Ham.preHWE.bim.tmp PIRE.Gmi.Ham.preHWE.bim
conda deactivate
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Gmi.Ham.preHWE.bed 1 --cv > PIRE.Gmi.Ham.preHWE.log1.out #run from 1-5
conda deactivate
```

Copied `*.eigenval`, `*.eigenvec` & `*.Q` files to local computer. Ran `pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R` on local computer to visualize PCA & ADMIXTURE results (figures in `/home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure`).

---

## Step 11. Filter VCF file for HWE

**NOTE:** If PCA & ADMIXTURE results don't show cryptic structure, skip to running `fltrVCF.sbatch`.

PCA & ADMIXTURE showed cryptic structure. ABas & CBas all assigned to one deme ("A"). ~50% of AHam & CBat assigned to same deme ("A") as ABas & CBas and ~50% assigned to separate deme ("B"). Species IDs unknown at this point.

Adjusted popmap file to reflect new structure.

```
cd /home/PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF
cp ../mkBAM/popmap.rad.RAW-10-10 ./popmap.rad.RAW-10-10.HWEsplit

#added -A or -B to end of pop assignment (second column) to assign individual to either group A or group B.
```

Ran `fltrVCF.sbatch`.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF
cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.HWE

#troubleshooting will be necessary
```

---

## Step 12. Make VCF with Monomorphic Loci

Moved the files needed for genotyping from `mkBAM` to `mkVCF`

```
#run in scratch if need more space
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta
mkdir mKVCF_monomorphic
mv mkBAM/*bam* mkVCF_monomorphic
cp mkBAM/*fasta mkVCF_monomorphic
cp mkBAM/config.5.cssl mkVCF_monomorphic
```

Changed the config file so that the last setting (monomorphic) is set to yes and renamed it with the suffix `.monomorphic`

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles,
```

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic
mv config.5.cssl config.5.cssl.monomrphic
```

Genotyped

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic
sbatch ../dDocentHPC_mkVCF.sbatch config.5.cssl.monomorphic
```

---

## Step 13. Filter VCF with monomorphic loci

Will filter for monomorphic & polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, probably best to do this in scratch.

Like with the original filtering step, because many *Gazza minuta* contemporary individuals had low numbers of reads, removed individuals with <100K sequences from VCF prior to running `fltrVCF.sbatch`.

```
#used same list as before (35 total, all contemporary)

cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load vcftools

vcftools --vcf ../mkBAM/TotalRawSNPs.rad.RAW-10.10.vcf --remove ../filterVCF/indvfewsequences.txt --recode --recode-INFO-all --out TotalRawSNPs.rad.RAW-10-10.noindvless100Kseq

mv TotalRawSNPs.rad.RAW-10.10.noindvless100Kseq.recode.vcf TotalRawSNPs.rad.RAW-10.10.noindvless100Kseq.vcf
```

Set-up filtering for monomorphic sites only.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic
cp ../scripts/config.fltr.ind.cssl.mono .
```

Ran `fltrVCF.sbatch` for monomorphic sites.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the TotalRawSNPs.noindvless100Kseq file made after the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file (step 9)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.mono

#troubleshooting will  be necessary
```

Set-up filtering for polymorphic sites only.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic
mkdir polymorphic_filter
cp ../../scripts/config.fltr.ind.cssl.poly .
```

Ran `fltrVCF.sbatch` for polymorphic sites.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the TotalRawSNPs.noindvless100Kseq file made after the "make monomorphic VCF" step
#popmap file should be file used in step 11, that accounts for any cryptic structure (*HWEsplit extension)
#settings should match the settings used when filtering the original VCF file (step 9)
sbatch ../../fltrVCF.sbatch config.fltr.ind.cssl.poly

#troubleshooting will be necessary
```

---

## Step 14. Merge monomorphic & polymorphic VCF files

Check monomorphic & polymorphic VCF file sto make sure that filtering removed the same individuals. If not, remove necessary individuals from files.

* mono.VCF: filtering removed ABas_001, ABas_004, ABas_008, ABas_028, ABas_030, ABas_033, ABas_034, ABas_035, ABas_045, ABas_047, ABas_049, ABas_055, ABas_058, ABas_059, ABas_060, AHam_001, AHam_015, AHam_074, CBas_013, CBas_015, CBas_017, CBas_019, CBas_034, CBas_038, CBas_041, CBas_068, CBas_069, CBas_082, CBas_092, CBas_095, CBat_002, CBat_013, CBat_036, CBat_047, CBat_058, CBat_062, CBat_070, CBat_071, CBat_093, CBat_094, CBat_095, ABas_017, AHam_002, CBas_014, CBas_049. Need to remove CBat_061 as well to match polymorphic VCF.
* poly.VCF: filtering removed ABas_001, ABas_004, ABas_008, ABas_028, ABas_030, ABas_033, ABas_034, ABas_035, ABas_045, ABas_047, ABas_049, ABas_055, ABas_058, ABas_059, ABas_060, AHam_001, AHam_015, AHam_074, CBas_013, CBas_015, CBas_017, CBas_019, CBas_034, CBas_038, CBas_041, CBas_068, CBas_069, CBas_082, CBas_092, CBas_095, CBat_002, CBat_013, CBat_036, CBat_047, CBat_058, CBat_062, CBat_070, CBat_071, CBat_093, CBat_094, CBat_095, ABas_017, AHam_002, CBas_014, CBas_049, CBat_061

Created `indv_missing.txt` in `mkVCF_monomorphic` directory. This is a list of all the individuals removed from either  file (total of 46 for Gmi). Used this list to make sure number of individuals matched in both filtered VCFs.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic
mv polymorphic_filter/gmi.poly.rad.RAW-10.10.Fltr17.20.recode.vcf .

module load vcftools

vcftools --vcf gmi.mono.rad.RAW-10.10.Fltr17.11.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing
mv gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.recode.vcf gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.vcf

vcftools --vcf gmi.poly.rad.RAW-10.10.Fltr17.20.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing
mv gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.recode.vcf gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.vcf
```

Sorted each VCF file.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load vcftools

#sort monomorphic
vcf-sort gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.vcf > gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf

#sort polymorphic
vcf-sort gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.vcf > gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf
```

Zipped each VCF file.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load samtools/1.9

#zip monomorphic
bgzip -c gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf > gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz

#zip polymorphic
bgzip -c  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf >  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Indexed each VCF file.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load samtools/1.9

#index monomorphic
tabix  gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz

#index polymorphic
tabix  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Merged files.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

crun bcftools concat --allow-overlaps  gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz -O z -o gmi.all.recode.nomissing.sorted.vcf.gz

tabix gmi.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses

## Merging .bam files from two separate runs (12/15/22)

Used the following command:

```
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta Gmi
```

Output: merged.bam files in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mergebams_run1run2
