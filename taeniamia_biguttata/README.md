# Tbi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Taeniamia biguttata* samples.

---

## Step 0.  Rename files for dDocent HPC

Raw data in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture` (check Taeniamia-biguttata channel on Slack).  Starting analyses in  `/home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_biguttata`.

Used decode file from Sharon Magnuson & Chris Bird.

```
salloc
bash

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture

#check got back sequencing data for all individuals in decode file
ls | wc -l #190 files (2 additional files for README & decode.tsv = 188/2 = 94 individuals (R&F)
wc -l Tbi_CaptureLibraries_SequenceNameDecode.tsv #95 lines (1 additional line for header = 94 individuals), checks out

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Tbi_CaptureLibraries_SequenceNameDecode.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Tbi_CaptureLibraries_SequenceNameDecode.tsv rename

cp *FileNames.txt /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture
```

Copied raw (renamed) `*fq.gz` files to the longterm Carpenter RC directory.

```
cd /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing
mkdir taeniamia_biguttata

cd taeniamia_biguttata
mkdir fq_raw_cssl

cp /home/e1garica/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture/* fq_raw_cssl/
```

---

## Step 1.  Check data quality with fastqc

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_biguttata

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture"

#once finished
mkdir /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_biguttata/Multi_FASTQC
mv /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/Multi_FASTQC/* /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_biguttata/Multi_FASTQC
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSTL3FL7PLEG5NMQOMOYTP7MWQ).

Potential issues:  
* % duplication - high acros the board, especially in Albatross
  * Alb: ~90%, Contemp: ~70%
* GC content - okay
  * Alb: 45-50%, Contemp: 40%
* number of reads - concerning
  * Alb: most <6 mil (very few 10-20 mil), Contemp: ~15-30 mil

---

## Step 2. 1st fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture fq_fp1
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1/1st_fastp_report.html?token=GHSAT0AAAAAABQHSGSS2ZXCJPQ5CRYO2ZVYYTP7KNA).

Potential issues:  
* % duplication - still very high acros the board
  * Alb: ~90%, Contemp: ~70%
* GC content - okay
  * Alb: 45-50%, Contemp: 40%
* passing filter - good
  * Alb: >95%, Contemp: >98%
* % adapter - high for Albatross, low for Contemp
  * Alb: >60% (a few 40-50%), Contemp: 20-30%
* number of reads - still low, esp for Albatross
  * Alb: most <10 mil (very few >10 mil), Contemp: ~15-30 mil

---

## Step 3. Clumpify

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#runCLUMPIFY_r1r2_array.bash <indir;fast1 files > <outdir> <tempdir> <max # of nodes to use at once>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/r3clark 10
```

Ran `checkClumpify.R` to see if any failed.

```
cd /scratch/r3clark/taeniamia_biguttata

salloc
module load container_env mapdamage2

crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save
#all files ran successfully
```

---

## Step 4. 2nd fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#runFASTP_2_cssl.sbatch <INDIR/full path to clumpified files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1_clmp_fp2/2nd_fastp_report.html?token=GHSAT0AAAAAABQHSGSSJCIKRCV74WTTRPDEYT5IFYA).

Potential issues:  
* % duplication - still high? Esp for Albatross
  * Alb: ~40-50%, Contemp: ~25%
* GC content - good
*  Alb: 40-50%, Contemp: 40%
* passing filter - great
  * Alb: >97%, Contemp: >99%
* % adapter - great
  * Alb: <2%, Contemp: <1%
* number of reads - Albatross took a big hit, Contemp ~okay
  * Alb: 1-5 mil, Contemp: 10-20 mil

---

## Step 5. Run fastq_screen

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```

Checked that all files were successfully completed.

```
cd /scratch/r3clark/taeniamia_biguttata

#checked that all 5 output files from fastqc screen were created for each file (should be 188 for each = 94 R1 & 94 R2)
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l #188
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l #188 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l #188
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l #188
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l #188

#checked all out files for any errors
grep 'error' slurm-fqscrn.*out #nothing
grep 'No reads in' slurm-fqscrn.*out #nothing
```

Everything looks good, no errors/missing files.

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1_clmp_fp2_fqscrn/fqscrn_mqc.html?token=GHSAT0AAAAAABQHSGSSPSC4KVGUJL5MXOFSYT6PBDQ).

Albatross has more contamination than Contemporary, but most reads come back as 'No hits' or 'Hits on multiple genomes'. Albatross have a few single hits to bacteria/protists, but not many. There are a few Albatross samples (Tbi-ARos_26-32) with more human and/or bacterial contamination but not an overwhelming amount.

---

## Step 6. Repair fastq_screen paired end files

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Once finished, ran multiqc to assess quality.

```
cd /scratch/r3clark/taeniamia_biguttata

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/scratch/r3clark/taeniamia_biguttata/fq_fp1_clmp_fp2_fqscrn_repaired"
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1_clmp_fp2_fqscrn_repaired/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSSYDGQMYMKQ7EB6TECYT6SIOQ).

---

## Step 7. Calculate the percent of reads lost in each step

Executed `read_calculator_cssl.sh`. Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#read_calculator_cssl.sh <Path to species home dir> <Path to dir with species raw files>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_cssl.sh "/scratch/r3clark/taeniamia_biguttata" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata"
```

Inspected these tables to see where most of the data was lost. Most data (~70-90%) lost during clumpify step, which makes sense (expect high level of duplication).

---

## Step 8. Set up mapping dir and get reference genome

Make mapping directory and move `*fq.gz` files over. Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata/
mkdir mkBAM

mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAM
```

Pulled latest changes from dDocentHPC repo & copied `config.5.cssl` over.

```
#if you haven't already, you first need to clone the dDocentHPC.git repo
#cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
#git clone https://github.com/cbirdlab/dDocentHPC.git

cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts/dDocentHPC
git pull

cd /scratch/r3clark/taeniamia_biguttata/mkBAM

cp /home/r3clark/PIRE/pire_cssl_data_processing/scripts/dDocentHPC/configs/config.5.cssl .
```

Found the best genome by running `wrangleData.R`, sorted tibble by busco single copy complete, quast n50, and filtered by species in Rstudio. The best genome to map to for *Taeniamia biguttata* is: **scaffolds.fasta** in `/home/e1garcia/shotgun_PIRE/tbi_spades/out_Tbi-C_500_R1R2ORPH_contam_noisolate_covcutoff-off`. Copied this to `mkBAM`.

```
cd /scratch/r3clark/taeniamia_biguttata/mkBAM

cp /home/e1garcia/shotgun_PIRE/tbi_spades/out_Tbi-C_500_R1R2ORPH_contam_noisolate_covcutoff-off/scaffolds.fasta .

#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv scaffolds.fasta ./reference.ssl.Tbi-C-500-R1R2ORPH-contam-noisolate.fasta
```

Updated the config file with the ref genome info.

```
cd /scratch/r3clark/taeniamia_biguttata/mkBAM
nano config.5.cssl
```

Inserted `<assembly type>` into the `Cutoff1` variable and `<unique assembly info>` into the `Cutoff2` variable.

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
ssl               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
Tbi-C-500-R1R2ORPH-contam-noisolate             Cutoff2 (integer)
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

## Step 9. Map reads to reference - Filter Maps - Genotype Maps

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../dDocentHPC.sbatch config.5.cssl
```

Handing off to George Bonsall for further processing.

---

11/23/22 - Brendan Reid remapping to the original "Ssp" probe development reference (true species identity = Tbi).

Get correct reference and config file, rename according to dDocent conventions, and edit config file to use this reference.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAM_Tbiref
cp ../mkBAM/config.5.cssl .
mv scaffolds.fasta reference.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate.fasta
vi config.5.cssl
```

Get script - still working from Ssp version - and run.
```
cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/mkBAM_probedevref/dDocentHPC.sbatch .
sbatch dDocentHPC.sbatch config.5.cssl
```

Script ran successfully except for the final indexing step. Resolve by manually indexing.

```
salloc
module load vcftools
module load htslib
vcf-sort TotalRawSNPs.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate.vcf.gz > TotalRawSNPs.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-resort.vcf
bgzip TotalRawSNPs.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-resort.vcf
tabix TotalRawSNPs.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-resort.vcf.gz
```

Checking the new mapping: view a few RG.bam files in IGV in relation to the bait locations (baits are the ones designed based on the "Ssp" genome - '/home/e1garcia/shotgun_PIRE/shotgun_baits/Siganus_spinus_chosen_baits.bed'). Based on IGV the new mapping looks correct - high coverage for contemporary and fairly good coverage for Albatross in most bait regions.

Copying the correct baits file to mkBAM_Tbiref and renaming with correct species name. Note a few things:
1) I have not yet renamed the bait file in /home/e1garcia/shotgun_PIRE/shotgun_baits/
2) Bait file has scaffold names with starting with ">" (like a .fasta file) - I had to remove these initial ">"s on my laptop for it to play properly with the reference genome file in IGV. I did not do this yet for the file in 

```
cp /home/e1garcia/shotgun_PIRE/shotgun_baits/Siganus_spinus_chosen_baits.bed /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/mkBAM_Tbiref/Taeniamia_biguttata_chosen_baits.bed
```

Renaming the original mkBAM folder to mkBAM_deprecated and the mkBAM_Tbiref folder to mkBAM. mkBAM now has the correct mapping files, the correct reference genome, and the correct bait files.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/
git mv mkBAM mkBAM_deprecated
git mv mkBAM_Tbiref mkBAM
```

## Preliminary filter (pre-HWE, before we check for structure/cryptic species) 

Clone Chris's fltrVCF and rad_haplotyper repos to species dir first 

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata 
git clone https://github.com/cbirdlab/fltrVCF.git
git clone https://github.com/cbirdlab/rad_haplotyper.git 

```

Move to fltrVCF dir, copy and modify config file (change name to indicate this is the first filter).

```
cd fltrVCF
cp config_files/config.fltr.ind.cssl ./
mv config.fltr.ind.cssl config.fltr.ind.cssl.1
```

See config file for changed settings - omitting the last 2 steps (HWE).

Grabbing the sbatch from `pire_cssl_data_processing/leiognathus_equula/fltrVCF` and running

```
cp ../../leiognathus_equula/fltrVCF/fltrVCF.sbatch .
sbatch fltrVCF.sbatch config.fltr.ind.cssl.1
```

Had to go back and manually unzip the vcf.gz for some reason!

Initial filtering kept many sites (106858!) but filtered out all of the Albatross individuals - possibly we are keeping many sites not covered by the baits that were genotyped for contemporary but not Albatross?. I am going to try again lowering the threshold for filter 5 to 0.8, which should reduce the # of sites but hopefully keep more Albatross?

```
sbatch fltrVCF.sbatch config.fltr.ind.cssl.2
```

Finished with a <10X fewer sites (10417) but retained 17 Albatross individuals.
