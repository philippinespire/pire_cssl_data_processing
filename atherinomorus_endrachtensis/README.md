# Aen Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Atherinomorus endrachtensis* samples from Hamilo Cove.

---

## Step 1.  1st fastp

Raw data in `/home/e1garcia/shotgun_PIRE/Aen/raw_fq` (check Atherinomorus-endrachtensis channel on Slack).  The root outdir for all analyses will be  `/home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus-endrachtensis`. Both on Wahab/Turing (ODU HPCs).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFASTP_1.sbatch <indir> <outdir>
sbatch runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Aen/raw_fq fq_fp1
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - high for most but not all Albatross, lower for contemporary
  * Alb: ~60% (some in the 40s), Contemp: ~45%
* GC content - good
  * Alb: 40%, Contemp: 45%
* passing filter - most reads passed filters for both Albatross & contemporary
  * Alb: >90% (some closer to 50-60% and those tend to be ones with lower % dup), Contemp: ~95%
* % adapter - high, esp. for Albatross
  * Alb: 80%, Contemp: 30-40%
* number of reads - seems to be okay
  * Alb: generally much higher # (>40 mil) BUT some are very low (1-2 mil), Contemp: ~10-20 mil

---

## Step 2. Clumpify

```
#on Turing
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

enable_lmod
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
sbatch runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/r3clark
```

Checked that all files ran with `checkCLUMPIFY.R`. All ran (no RAM issues).

---

## Step 3. Run fastp2

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFASTP_2.sbatch <indir> <outdir>
sbatch runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1_clmp_fp2/2nd_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - good
  * Alb: ~10%, Contemp: ~10%
* GC content - good
*  Alb: 40%, Contemp: 45%
* passing filter - good
  * Alb: ~98%, Contemp: ~99%
* % adapter - good
  * Alb: <2%, Contemp: <1%
* number of reads - took a hit, especially Albatross
  * Alb: about half ~10-25 mil & about half ~1-7 mil, Contemp: 5-10 mil

---

## Step 4. Run fastq_screen

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously>
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20

#check output for errors
grep 'error' slurm-fqscrn.266930*out | less -S #nothing
grep 'error' slurm-fqscrn.266930*out | less -S #nothing
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1_clmp_fp2_fqscrn/fqscrn_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:
* None. Not many hits to other genomes. What did hit was to bacteria/protist and Albatross generally slightly more contam than contemp.

Cleanup logs

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

mkdir logs
mv *out logs
```
---

## Step 5. Repair fastq_screen paired end files

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch ruNREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

---

## Step 6. Rename files for dDocent HPC and put into mapping dir

Used decode file from Sharon Magnuson & Chris Bird.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#mkNewFileNames.bash <decode file name> <fqdir>
bash ../scripts/mkNewFileNames.bash Aen_CaptureLibraries_SequenceNameDecode.txv fq_fp1_clmp_fp2_fqscrn_repaired > decode_newnames.txt

#make old file names
ls fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz > decode_oldnames.txt

#triple check that the old and new files are aligned
module load parallel
bash
parallel --no-notice --link -kj6 "echo {1}, {2}" :::: decode_oldnames.txt decode_newnames.txt > decode_translation.csv
less -S decode_translation.csv

#rename files and move to mapping dir
mkdir mkBAM
parallel --no-notice --link -kj6 "mv {1} mkBAM/{2}" :::: decode_oldnames.txt decode_newnames.txt

#confirm success
ls mkBAM
```

---

## Step 7.  Set up mapping dir and get reference genome

Cloned dDocentHPC repo.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
git clone git@github.com:cbirdlab/dDocentHPC.git

cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis
cp ../scripts/dDocentHPC/configs/config.5.cssl mkBAM
```

Because there is no whole genome reference for *A. endrachtensis*, I am using the full "raw" reference fasta from the RAD data used to make probes.

```
#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM/PIRE_AtherinomorousEndrachtensis.A.6.6.probes4development.fasta reference.rad.RAW-6-6.fasta
```

Updated the config file with the ref genome info

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM
nano config.5.cssl
```

Inserted `<assembly type>` into `Cutoff1` variable and `<unique assembly info>` into `Cutoff2` variable

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
rad               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
RAW-6-6               Cutoff2 (integer)
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
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

#this has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1  shot
sbatch ../dDocentHPC.sbatch config.5.cssl
```

---

## Step 9. Filter VCF Files (up to Allele Balance)

Originally filtered usual way (applying all filters in order in `config.fltr.ind.cssl` file with default settings). However, results of some filters (particularly the filter for AB) indicated *A. endrachtensis* is likely polyploid (octoploid) and/or is currently undergoing rediploidization genome duplication events. To deal with this, we have decided to filter *A. endrachtensis* in a slightly different manner, to try and maximize the number of diploid loci and minimize the number of polyploid loci retained in the final VCF file. 

Cloned fltrVCF and rad_haplotyper repos.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
git clone git@github.com:cbirdlab/fltrVCF.git
git clone git@github.com:cbirdlab/rad_haplotyper.git

cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis
mkdir filterVCF

cp ../scripts/fltrVCF/config_files/config.fltr.ind.cssl filterVCF
```

Ran `fltrVCF.sbatch`. Only running up to **Filter 15**.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF
mv config.fltr.ind.cssl config.fltr.ind.cssl.AB

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to Filter 15 (remove rest of the filters from config file)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.AB

#troubleshooting will be necessary
```

---

## Step 10. Create Octoploid VCF

Created so can compare genotype calls in homozygous sites. Will filter out sites where genotype calls differ between VCFs created with different ploidy levels (diploid v. octoploid) downstream.

Moved the files need for genotyping from `mkBAM` to `mkBAM/mkVCF_octoploid`

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM
mkdir mkVCF_octoploid

mv *bam* mkVCF_octoploid
mv namelist* mkVCF_octoploid
cp *fasta mkVCF_octoploid
cp config.5.cssl mkVCF_octoploid
```

Changed the config file so that the ploidy setting in the mkVCF section is set to 8 and renamed it with the suffix `.octo`

```
8      freebayes -p  --ploidy (integer)                      Whether pooled or not, if no cnv-map file is provided, then what is the ploidy of the samples? for pools, this number should be the number of individuals * ploidy
```

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM/mkVCF_octoploid
mv config.5.cssl conf.5.cssl.octo
```

Genotyped

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM/mkVCF_octoploid
sbatch ../../dDocentHPC_mkVCF.sbatch config.5.cssl.octo
```

---

## Step 11. Filter Octoploid VCF

Need to remove non-biallelic SNPs and indels. Can't use VCFtools for filtering because it won't work with polyploidy data. Used BCFtools instead.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF
mkdir filterVCF_octoploid

cd filterVCF_octoploid
cp ../../mkBAM/mkVCF_octoploid/TotalRawSNPs.rad.RAW-6-6.vcf .
```

```
#grab interactive node
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF/filterVCF_octoploid

module load container_env
module load bcftools

#filter out indels
crun bcftools filter -i 'TYPE="snp"' TotalRawSNPs.rad.RAW-6-6 > noindels.vcf

#filter to only biallelic SNPs
crun bcftools view -m2 -M2 noindels.vcf > noindels.biallelic.vcf
```

---

## Step 12. Pull Genotype & Allele Depth Data From VCFs

Followed `pire_cssl_data_processing/scripts/indvAlleleBalance.bash` script to create files.

For diploid data:

```
#grab interactive node
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

salloc
enable_lmod
module load container_env ddocent
bash

#set variables
VCFFILE=Aen.AB.rad.RAW-6-6.Fltr15.9.recode.vcf
JUNK_PATTERN=_.*-..-.*-.*_.*_L1_clmp_fp2_repr
NUM_CHR_ID=21
FILE_PREFIX=$(echo $VCFFILE | sed 's/vcf//')

#make header
paste <(echo -e 'chrom\tpos\tref\talt\tqual') <(crun vcf-query $VCFFILE -l | cut -c1-$NUM_CHR_ID | tr "\n" "\t" ) > individuals.tsv

#extract columns of info from VCF (test files first, limits records to 100 SNPs)
#format of resulting files is: CHROM, POS, REF, ALT, QUAL, IND1 ...
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}AD.tsv #allele depth info
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}GT.tsv #genotype info

#open one of the files up to make sure it looks okay

#extract columns of info from VCF (no limits)
#format of resulting files is: CHROM, POS, REF, ALT, QUAL, IND1 ...
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' | sed 's/\t$//' ) > ${FILE_PREFIX}AD.tsv #allele depth info
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' | sed 's/\t$//' ) > ${FILE_PREFIX}GT.tsv #genotype info
```

For octoploid data:

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF/filterVCF_octoploid

#set variables
VCFFILE=noindels.biallelic.vcf
JUNK_PATTERN=_.*-..-.*-.*_.*_L1_clmp_fp2_repr
NUM_CHR_ID=21
FILE_PREFIX=$(echo $VCFFILE | sed 's/vcf//')

#make header
paste <(echo -e 'chrom\tpos\tref\talt\tqual') <(crun vcf-query $VCFFILE -l | cut -c1-$NUM_CHR_ID | tr "\n" "\t" ) > individuals.tsv

#extract columns of info from VCF (test files first, limits records to 100 SNPs)
#format of resulting files is: CHROM, POS, REF, ALT, QUAL, IND1 ...
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}AD.tsv #allele depth info
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}GT.tsv #genotype info

#open one of the files up to make sure it looks okay

#extract columns of info from VCF (no limits)
#format of resulting files is: CHROM, POS, REF, ALT, QUAL, IND1 ...
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' | sed 's/\t$//' ) > ${FILE_PREFIX}AD.tsv #allele depth info
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' | sed 's/\t$//' ) > ${FILE_PREFIX}GT.tsv #genotype info
```

---

## Step 13. Filter to Diploid Sites

Ran `pire_cssl_data_processing/scripts/diploid_filter.R` to create a "greenlist" of loci that meet diploid assumptions. Assumed loci that fell under a heterozygosity cut-of of 0.6 and had a z-score between -2.5 & 2.5 were diploid. Followed McKinney et al. (2017) [guidelines](https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.12613).

Took created greenlist and filtered VCF to just those loci.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

module load vcftools

vcftools --vcf Aen.AB.rad.RAW-6-6.Fltr15.9.recode.vcf --positions greenlist_loci_full_HD_2.5.txt --recode --recode-INFO-all --out Fltr15.9.greenlistHD2.5
mv Fltr15.9.greenlistHD2.5.recode.vcf Fltr15.9.greenlistHD2.5.vcf
```

---

## Step 14. Filter VCF Files

Ran `fltrVCF.sbatch`. From original list of filters, only running those **after Filter 06** and up to **second 07 filter**. Not running allele balance filter at all (essentially did that when applied z-score & heterozygosity cut-offs).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF
mv config.fltr.ind.cssl.AB config.fltr.ind.cssl.postAB_HD

#before running, make sure the config file is updated with file paths and file extensions based on your species
#vcf path should point to vcf made after removing loci not in greenlist (the file just created by vcftools)
#config file should ONLY run filters 11 09 10 04 13 05 16 07 (in that order)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.postAB_HD

#troubleshooting will be necessary
```

---

## Step 15. Check for cryptic species

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis
mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCF/*Fltr07.9.vcf .

#rename individuals (too many underscores in original names)
module load container_env
module load bcftools

crun bctools reheader -s sample_names.txt -o Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.9.rename.vcf Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.9.vcf
```

Ran PCA w/PLINK. Instructions for installing PLINK with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure

module load anaconda
conda activate popgen

plink --vcf Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.9.rename.vcf --allow-extra-chr --pca --out PIRE.Aen.Ham.preHWE
conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure

module load anaconda
conda activate popgen

plink --vcf Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.9.rename.vcf --allow-extra-chr --make-bed --out PIRE.Aen.Ham.preHWE

awk '{$1=0;print $0}' PIRE.Aen.Ham.preHWE.bim > PIRE.Aen.Ham.preHWE.bim.tmp
mv PIRE.Aen.Ham.preHWE.bim.tmp PIRE.Aen.Ham.preHWE.bim
conda deactivate
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Aen.Ham.preHWE.bed 1 --cv > PIRE.Aen.Ham.preHWE.log1.out #run from 1-5
conda deactivate
```

Copied `*.eigenval`, `*.eigenvec` & `*.Q` files to local computer. Read `*.eigenvec` file into Excel to create a .csv file. Ran `pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R` on local computer to visualize PCA & ADMIXTURE results (figures in `/home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure`).

## Step 16. Filter VCF file for HWE

**NOTE:** If PCA & ADMIXTURE results don't show cryptic structure, skip to running `fltrVCF.sbatch`.

PCA & ADMIXTURE showed a tiny bit of cryptic structure. AHam all assigned to one deme ("A"). Most of Cbat assigned to same except for 3 (assigned to "B"). Species IDs unknown at this point.

Adjusted popmap file to reflect new structure.

```
cd /home/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF
cp ../mkBAM/popmap.rad.RAW-6-6 ./popmap.rad.RAW-6-6.HWEsplit

#added -A or -B to end of pop assignment (second column) to assign individual to either group A or group B
#had to change individual names to match vcf naming structure as well
```

Ran `fltrVCF.sbatch`.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF
cp config.fltr.ind.cssl.AB ./config.fltr.ind.cssl.HWE

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.HWE

#troubleshooting will be necessary
```

---

## Step 17. Make VCF with Monomorphic Loci

Moved the files needed for genotyping from `mkBAM` to `mkVCF`

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis
mkdir mkVCF_monomorphic
mv mkBAM/mkVCF_octoploid/*bam* mkVCF_monomorphic
mv mkBAM/mkVCF_octoploid/namelist* mkVCF_monomorphic
cp mkBAM/*fasta mkVCF_monomorphic
cp mkBAM/config.5.cssl mkVCF_monomorphic/
```

Changed the config file so that the last setting (monomorphic) is set to yes and renamed it with the suffix `.monomorphic`

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles, even those which are not in called genotypes. Loci which do not have any potential alternates have '.' for ALT.
```

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkVCF_monomorphic
mv config.5.cssl config.5.cssl.monomorphic
```

Genotyped

```
cd /home/cbird/pire_cssl_data_processing/atherinomorus_endrachtensis/mkVCF_monomorphic
sbatch ../dDocentHPC_mkVCF.sbatch config.5.cssl.monomorphic #NOTE: ran on Turing bc Wahab queue was backed up
```
