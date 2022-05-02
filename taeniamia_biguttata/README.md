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

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1_clmp_fp2/2nd_fastp_report.html?token=GHSAT0AAAAAABQHSGSSBHR62HFBBYZK46R4YTQHTJA).

Potential issues:  
* % duplication - still high? Esp for Albatross
  * Alb: ~40-50%, Contemp: ~25%
* GC content - good
*  Alb: 40-50%, Contemp: 40%
* passing filter - good
  * Alb: >97%, Contemp: >99%
* % adapter - good
  * Alb: <2%, Contemp: <1%
* number of reads - Albatross took a big hit, Contemp ~okay
  * Alb: 1-5 mil, Contemp: 10-20 mil

---
