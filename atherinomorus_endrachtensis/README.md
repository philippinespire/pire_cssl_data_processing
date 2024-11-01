# Aen Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Atherinomorus endrachtensis* samples from Hamilo Cove.

---

## 0. FastQC

Raw data in `/home/e1garcia/shotgun_PIRE/Aen/raw_fq` (check *Atherinomorus endrachtensis* channel on Slack). Starting analyses in `/home/e1garcia/shotgun_PRIE/pire_cssl_data_processing/atherinomorus_endrachtensis`.

Ran `Multi_FASTQC.sh`. Copied fq files over to own `fq_raw` directory and ran fastQC there.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fq_raw

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fq_raw" "fq.gz"
```

Potential issues:
  * % duplication -
    * Alb: ~75% (some in the 40s), Contemp: ~50%
  * GC content - good
    * Alb: ~45-50%, Contemp: 45%
  * number of reads - seems to be okay
    * Alb: generally much higher # (>40 mil) BUT some are very low (1-2 mil), Contemp: ~10-20 mil

---

## 1.  1st fastp

Ran `runFASTP_1st_trim.sbatch`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

sbatch ../../pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
```

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

## 2. Clumpify

Ran `runCLUMPIFY_r1r2_array.bash`.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

bash ../../pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch-lustre/r3clark 10
```

Checked that all files ran with `checkCLUMPIFY_EG.R`. All ran (no RAM issues).

---

## 3. Run fastp2

Ran `runFASTP_2_cssl.sbatch`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

sbatch ../../pire_fq_gz_processing/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

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

## 4. Run fastq_screen

Ran `runFQSCRN_6.bash`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

bash ../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20

#check output for errors
grep 'error' slurm-fqscrn.266930*out | less -S #nothing
grep 'No reads in' slurm-fqscrn.266930*out | less -S #nothing
```

Potential issues:
* None. Not many hits to other genomes. What did hit was to bacteria/protist and Albatross generally slightly more contam than contemp.

Cleanup logs

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

mkdir logs
mv *out logs
```

---

## 5. Re-pair fastq_screen paired end files

Ran `runREPAIR.sbatch`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

sbatch ../../pire_fq_gz_processing/ruNREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

---

## 6. Rename files for dDocent HPC and put into mapping dir

Used decode file from Sharon Magnuson & Chris Bird.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

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

## 7.  Set up mapping dir and get reference genome

Copied `config.6.cssl` over to mapping dir.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

cp ../../scripts/dDocentHPC/configs/config.6.cssl .
```

Because there is no whole genome reference for *A. endrachtensis*, I am using the full "raw" reference fasta from the RAD data used to make probes. This file can be found on Wahab in `/RC/group/rc_carpenterlab_ngs/rad_PIRE/Aen` in the zipped `PIRE-Aen-C-Bat_probedev.tar.gz` file. Copied over to the mapping dir and renamed.
  * Reference fasta also lives in `/home/e1garcia/shotgun_PIRE/pire_probe_sets/04_Atherinomorus_endrachtensis` as well (as `pire_AtherinomorusEndrachtensis_ArborBioSciProbeSet_unfiltered.fasta`).

```
#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM/PIRE_AtherinomorousEndrachtensis.A.6.6.probes4development.fasta reference.rad.RAW-6-6.fasta
```

Updated the config file with the ref genome info

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

nano config.6.cssl
```

Inserted `<assembly type>` into `Cutoff1` variable and `<unique assembly info>` into `Cutoff2` variable

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)           PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
rad             Cutoff1 (integer)                                      Use unique reads that have at least this much coverage for making the reference     genome
RAW-6-6         Cutoff2 (integer)                                      Use unique reads that occur in at least this many individuals for making the reference genome
0.05            rainbow merge -r <percentile> (decimal 0-1)            Percentile-based minimum number of seqs to assemble in a precluster
0.95            rainbow merge -R <percentile> (decimal 0-1)            Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------

----------mkBAM: Settings for mapping the reads to the reference genome-------------------------------------------
Make sure the cutoffs above match the reference*fasta!
1               bwa mem -A Mapping_Match_Value (integer)
4               bwa mem -B Mapping_MisMatch_Value (integer)
6               bwa mem -O Mapping_GapOpen_Penalty (integer)
30              bwa mem -T Mapping_Minimum_Alignment_Score (integer)                    Remove reads that have an alignment score less than this.
5               bwa mem -L Mapping_Clipping_Penalty (integer,integer)
------------------------------------------------------------------------------------------------------------------
```

---

## 8. Map reads to reference

Ran `dDocentHPC.sbatch`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

sbatch ../../../dDocentHPC/dDocentHPC.sbatch mkBAM config.6.cssl
```

---

 ## 9. Filter BAM files

Ran `dDocentHPC.sbatch`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

sbatch ../../../dDocentHPC/dDocentHPC.sbatch fltrBAM config.6.cssl
```

---

## 10. Generate mapping stats for capture targets

Ran `getBAITcvg.sbatch` to calculate the breadth and depth of coverage for the targeted bait regions:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

sbatch ../../scripts/getBAITcvg.sbatch . /home/e1garcia/shotgun_PIRE/pire_probe_sets/04_Atherinomorus_endrachtensis/Atherinomorus_endrachtensis_Chosen_baits.singleLine.bed
```

Ran `mappedReadStats.sbatch` to calculate the number of reads in each filtered `.bam` file, along with their mean length and depth:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

sbatch ../../../pire_fq_gz_processing/mappedReadStats.sbatch . coverageMappedReads
```

---

## 11. Run mapDamage

Ran mapDamage:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

sbatch ../../scripts/runMAPDMG.2.sbatch "Aen-*RG.bam" reference.rad.RAW-6-6.fasta
```

Cleaning up directories:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

mkdir mapDamage_output
mv results*-RG/ mapDamage_output

cd ..
mkdir mapdamageBAM

cd mapDamageBAM
mv ../mkBAM/mapDamage_output/results*/*bam .
```

Renamed the rescaled .bam files so that dDocent will recognize them (made them end in *-rescaled-RG.bam).

---

## 12. Run mkVCF on BAM files

Copied and renamed reference fasta and `config.6.cssl` to `mapDamageBAM`:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mapDamageBAM

cp ../mkBAM/reference.rad.RAW-6-6.fasta ./reference.rad.RAW-6-6-rescaled.fasta
cp ../mkBAM/config.6.cssl ./config.6.cssl.mkVCF.rescale
```

Edited `config.6.cssl.mkVCF.rescale` so that the file names match and the settings are as desired:

```sh
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE                       Type of reads for assembly (PE, SE, OL, RPE)           PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
rad                      Cutoff1 (integer)                                      Use unique reads that have at least this much coverage for making the reference     genome
RAW-6-6-rescaled         Cutoff2 (integer)                                      Use unique reads that occur in at least this many individuals for making the reference genome
0.05                     rainbow merge -r <percentile> (decimal 0-1)            Percentile-based minimum number of seqs to assemble in a precluster
0.95                     rainbow merge -R <percentile> (decimal 0-1)            Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------
```

Ran mkVCF:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mapDamageBAM

sbatch ../../../dDocentHPC/dDocentHPC.sbatch fltrBAM config.6.cssl.mkVCF.rescale
```

---

## 14. Filter VCF files (up to allele balance)

Originally filtered usual way (applying all filters in order in `config.fltr.ind.cssl` file with default settings). However, results of some filters (particularly the filter for AB) indicated *A. endrachtensis* is likely polyploid (octoploid) and/or is currently undergoing rediploidization genome duplication events. To deal with this, we have decided to filter *A. endrachtensis* in a slightly different manner, to try and maximize the number of diploid loci and minimize the number of polyploid loci retained in the final VCF file. 

Made a filtering directory and copied config file over:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

mkdir filterVCF
cd filterVCF

cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl.AB .
```

Updated config file with correct paths:

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15                                  # order to run filters in
        fltrVCF -c rad.RAW-6-6-rescaled                                        # cutoffs, ie ref description
        fltrVCF -b ../mapDamageBAM                                             # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                               # path to fltrVCF R scripts
        fltrVCF -d ../mapDamageBAM/mapped.rad.RAW-6-6-rescaled.bed             # bed file used in genotyping
        fltrVCF -v ../mapDamageBAM/TotalRawSNPs.rad.RAW-6-6-rescaled.vcf       # vcf file to filter
        fltrVCF -g ../mapDamageBAM/reference.rad.RAW-6-6-rescaled.fasta        # reference genome
        fltrVCF -p ../mapDamageBAM/popmap.rad.RAW-6-6-rescaled                 # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl              # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl              # path to rad_haplotyper script
        fltrVCF -o Aen.AB                                                      # prefix on output files, use to track settings
        fltrVCF -t 32                                                          # number of threads [1]
```

Adjusted fltrVCF settings as follows:

```
Filters
        01 vcftools --min-alleles       2               #Remove sites with less alleles [2]
        01 vcftools --max-alleles       2               #Remove sites with more alleles [2]
        02 vcftools --remove-indels                     #Remove sites with indels.  Not adjustable
        03 vcftools --minQ              100             #Remove sites with lower QUAL [20]
        04 vcftools --min-meanDP        5:15            #Remove sites with lower mean depth [15]
        05 vcftools --max-missing       0.55:0.6        #Remove sites with at least 1 - value missing data (1 = no missing data) [0.5]
        07 vcffilter AC min             0               #Remove sites with equal or lower MINOR allele count [3]
        14 vcftools --minDP             5               #Code genotypes with lesser depth of coverage as NA [5]
        15 vcftools --maf               0               #Remove sites with lesser minor allele frequency.  Adjust based upon sample size. [0.005]
        15 vcftools --max-maf           1               #Remove sites with greater minor allele frequency.  Adjust based upon sample size. [0.995]
        16 vcftools --missing-indv      0.6:0.5         #Remove individuals with more missing data. [0.5]
```
       
Ran `fltrVCF.sbatch`. Only running up to **Filter 15**.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to Filter 15 (remove rest of the filters from config file)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.AB
```

---

## 15. Create octoploid VCF

Created so can compare genotype calls in homozygous sites. Will filter out sites where genotype calls differ between VCFs created with different ploidy levels (diploid v. octoploid) downstream.

Copied and moved the files need for genotyping from `mapDamageBAM` to `mapDamageBAM/mkVCF_octoploid`

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mapDamageBAM
mkdir mkVCF_octoploid

ln *bam* mkVCF_octoploid
mv namelist* mkVCF_octoploid
cp *fasta mkVCF_octoploid
cp config.6.cssl.mkVCF.rescale mkVCF_octoploid
```

Changed the config file so that the ploidy setting in the mkVCF section is set to 8 and renamed it with the suffix `.octo`

```
8      freebayes -p  --ploidy (integer)       Whether pooled or not, if no cnv-map file is provided, then what is the ploidy of the samples? for pools, this number should be the number of individuals * ploidy
```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mapDamageBAM/mkVCF_octoploid

mv config.6.cssl.mkVCF.rescale config.6.cssl.mkVCF.rescale.octo
```

Genotyped

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mapDamageBAM/mkVCF_octoploid

sbatch ../../../../dDocentHPC/dDocentHPC.sbatch mkVCF config.6.cssl.mkVCF.rescale.octo
```

---

## 16. Filter octoploid VCF

Need to remove non-biallelic SNPs and indels. Can't use VCFtools for filtering because it won't work with polyploidy data. Used BCFtools instead.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

mkdir filterVCF_octoploid
cd filterVCF_octoploid

cp ../../mapDamageBAM/mkVCF_octoploid/TotalRawSNPs.rad.RAW-6-6-rescaled.vcf .
```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF/filterVCF_octoploid

module load container_env bcftools
bash
export SINGULARITY_BIND=/home/e1garcia

#filter out indels
crun bcftools filter -i 'TYPE="snp"' TotalRawSNPs.rad.RAW-6-6-rescaled > noindels.vcf

#filter to only biallelic SNPs
crun bcftools view -m2 -M2 noindels.vcf > noindels.biallelic.vcf
```

---

## 17. Pull genotype & allele depth data from VCFs

Followed `pire_cssl_data_processing/scripts/indvAlleleBalance.bash` script to create files.

For diploid data:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

module load container_env ddocent
bash
export SINGULARITY_BIND=/home/e1garcia

#set variables
VCFFILE=Aen.AB.rad.RAW-6-6-rescaled.Fltr15.9.recode.vcf
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

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF/filterVCF_octoploid

module load container_env ddocent
bash
export SINGULARITY_BIND=/home/e1garcia

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

## 18. Filter to diploid contigs

Ran `pire_cssl_data_processing/scripts/diploid_filter.R` to create a "greenlist" of contigs that meet diploid assumptions. Assumed loci that fell under a heterozygosity cut-of of 0.6 and had a z-score between -2.5 & 2.5 were diploid. Kept list of contigs with >80% of loci passing diploid (HD) filters. Followed McKinney et al. (2017) [guidelines](https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.12613).

Took created greenlist and filtered VCF to just those contigs.
  * Kept 23,876 loci across 9,547 contigs.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

module load vcftools
bash
export SINGULARITY_BIND=/home/e1garcia

vcftools --vcf Aen.AB.rad.RAW-6-6-rescaled.Fltr15.9.recode.vcf --positions diploid_contigs.bed --recode --recode-INFO-all --out Fltr15.9.greenlist
mv Fltr15.9.greenlist.recode.vcf Fltr15.9.greenlist.vcf
```

---

## 19. Filter VCF file

Ran `fltrVCF.sbatch`. From original list of filters, only running those **after Filter 06** and up to **second 07 filter**. Not running allele balance filter at all (essentially did that when applied z-score & heterozygosity cut-offs).

Copied `config.fltr.ind.cssl.AB` to new config file for just postAB-preHWE filtering:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

cp config.fltr.ind.cssl.AB config.fltr.ind.cssl.postAB_HD
```

Updated config file with correct paths:

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 11 09 10 04 13 05 16 07                                     # order to run filters in
        fltrVCF -c rad.RAW-6-6-rescaled                                        # cutoffs, ie ref description
        fltrVCF -b ../mapDamageBAM                                             # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                               # path to fltrVCF R scripts
        fltrVCF -d ../mapDamageBAM/mapped.rad.RAW-6-6-rescaled.bed             # bed file used in genotyping
        fltrVCF -v Fltr15.9.greenlist.vcf                                      # vcf file to filter
        fltrVCF -g ../mapDamageBAM/reference.rad.RAW-6-6-rescaled.fasta        # reference genome
        fltrVCF -p ../mapDamageBAM/popmap.rad.RAW-6-6-rescaled                 # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl              # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl              # path to rad_haplotyper script
        fltrVCF -o Aen.postAB_HD2.5                                            # prefix on output files, use to track settings
        fltrVCF -t 32                                                          # number of threads [1]
```

Adjusted fltrVCF settings as follows:

```
Filters
        04 vcftools --min-meanDP        5:15            #Remove sites with lower mean depth [15]
        05 vcftools --max-missing       0.55:0.6        #Remove sites with at least 1 - value missing data (1 = no missing data) [0.5]
        07 vcffilter AC min             0               #Remove sites with equal or lower MINOR allele count [3]
        09 vcffilter MQM/MQMR min       0.25            #Remove sites where the difference in the ratio of mean mapping quality between REF and ALT alleles is greater than this proportion from 1. Ex: 0 means the mapping quality must be equal between REF and ALTERNATE. Smaller numbers are more stringent. Keep sites where the following is true: 1-X < MQM/MQMR < 1/(1-X) [0.1]
        10 vcffilter PAIRED                             #Remove sites where one of the alleles is only supported by reads that are not properly paired (see SAM format specification). Not adjustable.
        11 vcffilter QUAL/DP min        0.02            #Remove sites where the ratio of QUAL to DP is deemed to be too low. [0.25]
        13 vcftools --max-meanDP        400             #Remove sites with higher mean depth [250]
        16 vcftools --missing-indv      0.6:0.5         #Remove individuals with more missing data. [0.5]
```

Ran `fltrVCF.sbatch`:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF

#before running, make sure the config file is updated with file paths and file extensions based on your species
#vcf path should point to vcf made after removing contigs not in greenlist (the file just created by vcftools)
#config file should ONLY run filters 11 09 10 04 13 05 16 07 (in that order)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.postAB_HD
```

---

## Step 15. Check for cryptic species

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis
mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCF/*Fltr07.8.vcf .

#rename individuals (too many underscores in original names)
module load container_env
module load bcftools

crun bctools reheader -s sample_names.txt -o Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.8.rename.vcf Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.8.vcf
```

Ran PCA w/PLINK. Instructions for installing PLINK with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure

module load anaconda
conda activate popgen

plink --vcf Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.8.rename.vcf --allow-extra-chr --pca --out PIRE.Aen.Ham.preHWE
conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure

module load anaconda
conda activate popgen

plink --vcf Aen.postAB_HD2.5.rad.RAW-6-6.Fltr07.8.rename.vcf --allow-extra-chr --make-bed --out PIRE.Aen.Ham.preHWE

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

Copied `*.eigenval`, `*.eigenvec` & `*.Q` files to local computer. Ran `pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R` on local computer to visualize PCA & ADMIXTURE results (figures in `/home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/pop_structure`).

---

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

## Step 17. Make VCF with monomorphic loci

Moved the files needed for genotyping from `mkBAM` to `mkVCF_monomorphic`. Did this in `scratch` because don't have enough room in `home`.

```
cd /scratch/r3clark/PIRE-Aen-Ham
mkdir mkVCF_monomorphic
mv mkBAM/mkVCF_octoploid/*bam* mkVCF_monomorphic
cp mkBAM/mkVCF_octoploid/namelist* mkVCF_monomorphic
cp mkBAM/*fasta mkVCF_monomorphic
cp mkBAM/config.5.cssl mkVCF_monomorphic/
```

Changed the config file so that the last setting (monomorphic) is set to yes and renamed it with the suffix `.monomorphic`

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles, even those which are not in called genotypes. Loci which do not have any potential alternates have '.' for ALT.
```

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic
mv config.5.cssl config.5.cssl.monomorphic
```

Genotyped.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic
sbatch /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/dDocentHPC_mkVCF.sbatch config.5.cssl.monomorphic #NOTE: ran on Turing bc Wahab queue was backed up
```

---

## Step 18. Filter VCF with monomorphic loci

Will filter for monomorphic & polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, probably best to do this in scratch.

Need to rename individuals in vcf (shorten names to match downstream `popmap` files).

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

module load container_env/0.1
module load bcftools

crun bcftools reheader -s rename_samples.txt TotalRawSNPs.rad.RAW-6-6.vcf > TotalRawSNPs.rad.RAW-6-6.rename.vcf
```

Set-up filtering for monomorphic sites only. Only filtering to "AB" step first (just like with original VCF filtering). Then will subset to diploid contigs and finish rest of `fltrVCF` pipeline.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic
cp /home/r3clark/PIRE/pire_cssl_data_processing/scripts/config.fltr.ind.cssl.mono ./config.fltr.ind.cssl.mono.AB
```

Ran `fltrVCF.sbatch` for monomorphic sites.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the TotalRawSNPs.rename file made after the "make monomorphic VCF" step
#ONLY running filters 01 02 04 14 05 16 (in that order) -- settngs should match the settings used when filtering the original VCF file (step 9)
sbatch /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fltrVCF.sbatch config.fltr.ind.cssl.mono.AB

#troubleshooting will  be necessary
```

Set-up filtering for polymorphic sites only.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic
mkdir polymorphic_filter
cd polymorphic_filter
cp /home/r3clark/PIRE/pire_cssl_data_processing/scripts/config.fltr.ind.cssl.poly ./config.fltr.ind.cssl.poly.AB
```

Ran `fltrVCF.sbatch` for polymorphic sites.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the TotalRawSNPs.rename file made after the "make monomorphic VCF" step
#ONLY running filters 01 02 03 04 14 07 05 16 15 (in that order) -- settngs should match the settings used when filtering the original VCF file (step 9)
sbatch /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fltrVCF.sbatch config.fltr.ind.cssl.poly.AB

#troubleshooting will be necessary
```

Because of polyploidy issues, next filtered both the monomorphic and polymorphic VCFs to a list of contigs that are "diploid" (same list as in Step 13).

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

salloc
module load vcftools

#diploid_contigs.bed is tab-delimited (bed) file with contig names, starting and ending positions each in a column (here, start = 1 and end = 100000 for al
vcftools --vcf aen.mono.rad.RAW-6-6.Fltr16.6.recode.vcf --bed diploid_contigs.bed --recode --recode-INFO-all --out aen.mono.rad.RAW-6-6.Fltr16.6.recode.diploid.vcf
mv aen.mono.rad.RAW-6-6.Fltr16.6.recode.diploid.vcf.recode.vcf aen.mono.rad.RAW-6-6.Fltr16.6.recode.diploid.vcf

cd polymorphic_filter
vcftools --vcf aen.poly.rad.RAW-6-6.Fltr15.9.recode.vcf --bed ../diploid_contigs.bed --recode --recode-INFO-all --out aen.poly.rad.RAW-6-6.Fltr15.9.recode.diploid.vcf
mv aen.poly.rad.RAW-6-6.Fltr15.9.recode.diploid.vcf.recode.vcf aen.poly.rad.RAW-6-6.Fltr15.9.recode.diploid.vcf
```

Finally, finished the rest of the filtering pipeline.

Ran `fltrVCF.sbatch` for monomorphic sites.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic
cp /home/r3clark/PIRE/pire_cssl_data_processing/scripts/config.fltr.ind.cssl.mono ./config.fltr.ind.cssl.mono.postAB_HD

#before running, make sure the config file is updated with file paths and file extensions based on your species
#vcf path should point to vcf made after removing contigs not in greenlist (the file just created by vcftools)
#ONLY running filters 04 13 05 16 17 (in that order) -- settngs should match the settings used when filtering the original VCF file (steps 14 & 16)
sbatch /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fltrVCF.sbatch config.fltr.ind.cssl.mono.postAB_HD

#troubleshooting will  be necessary
```

Ran `fltrVCF.sbatch` for polymorphic sites.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkVCF_monomorphic/polymorphic_filter
cp /home/r3clark/PIRE/pire_cssl_data_processing/scripts/config.fltr.ind.cssl.poly ./config.fltr.ind.cssl.poly.postAB_HD

#before running, make sure the config file is updated with file paths and file extensions based on your species
#vcf path should point to vcf made after removing contigs not in greenlist (the file just created by vcftools)
#popmap file should be file used in step 16, that accounts for any cryptic structure (*HWEsplit extension)
#ONLY running filters 11 09 10 04 13 05 16 07 18 (in that order) -- settngs should match the settings used when filtering the original VCF file (steps 14 & 16)
sbatch /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fltrVCF.sbatch config.fltr.ind.cssl.poly.AB

#troubleshooting will be necessary
#here, not running 17 at end because removes sites due to one (small) pop (AHam-B) having a lot of missing sites
```

---

## Step 19. Merge monomorphic & polymorphic VCF files

Check monomorphic & polymorphic VCF file sto make sure that filtering removed the same individuals. If not, remove necessary individuals from files.

* mono.VCF: filtering removed AHam_004, AHam_005, AHam_010, AHam_016, AHam_020, AHam_021, AHam_023, AHam_029, AHam_031, AHam_036, AHam_037, AHam_038, AHam_040, AHam_043, AHam_053, AHam_057, AHam_011, AHam_024, AHam_032, AHam_046, AHam_052, AHam_058, AHam_059.
* poly.VCF: filtering removed AHam_004, AHam_005, AHam_010, AHam_016, AHam_020, AHam_021, AHam_023, AHam_029, AHam_031, AHam_036, AHam_037, AHam_038, AHam_040, AHam_043, AHam_053, AHam_057, AHam_011, AHam_024, AHam_032, AHam_046, AHam_052, AHam_058, AHam_059. 

All match. No need to remove more individuals from either VCF file.

Sorted each VCF file.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

module load vcftools

#sort monomorphic
vcf-sort aen.mono.rad.RAW-6-6.Fltr17.5.recode.vcf > aen.mono.rad.RAW-6-6.Fltr17.5.recode.sorted.vcf 

#sort polymorphic
vcf-sort aen.poly.rad.RAW-6-6.Fltr18.9.HWE.recode.vcf > aen.poly.rad.RAW-6-6.Fltr18.9.HWE.recode.sorted.vcf
```

Zipped each VCF file.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

module load samtools/1.9

#zip monomorphic
bgzip -c aen.mono.rad.RAW-6-6.Fltr17.5.recode.sorted.vcf > aen.mono.rad.RAW-6-6.Fltr17.5.recode.sorted.vcf.gz

#zip polymorphic
bgzip -c  aen.poly.rad.RAW-6-6.Fltr18.9.HWE.recode.sorted.vcf > aen.poly.rad.RAW-6-6.Fltr18.9.HWE.recode.sorted.vcf.gz
```

Indexed each VCF file.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

module load samtools/1.9

#index monomorphic
tabix  aen.mono.rad.RAW-6-6.Fltr17.5.recode.sorted.vcf.gz

#index polymorphic
tabix  aaen.poly.rad.RAW-6-6.Fltr18.9.HWE.recode.sorted.vcf.gz
```

Merged files.

```
cd /scratch/r3clark/PIRE-Aen-Ham/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

crun bcftools concat --allow-overlaps  aen.mono.rad.RAW-6-6.Fltr17.5.recode.sorted.vcf.gz  aen.poly.rad.RAW-6-6.Fltr18.9.HWE.recode.sorted.vcf.gz -O z -o aen.all.recode.sorted.vcf.gz

tabix aen.all.recode.sorted.vcf.gz #index all sites VCF for downstream analyses
```
