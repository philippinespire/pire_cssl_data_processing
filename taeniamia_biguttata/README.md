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

Ran in `scratch` because don't have enough space in `home` directory. Hard trimming the first 15 nucleotides to get rid of the `CTNAAATTT` motif we are seeing at the beginning of reads.

```
cd /scratch/r3clark/taeniamia_biguttata

#runFASTP_2_cssl.sbatch <INDIR/full path to clumpified files> <OUTDIR/full path to desired outdir> <OPTIONAL #bp to trim from left>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2 15
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1_clmp_fp2/2nd_fastp_report.html?token=GHSAT0AAAAAABQHSGSTASYT4PWPLCRAIKOSYTT6A3A).

Potential issues:  
* % duplication - still high? Esp for Albatross
  * Alb: ~40-50%, Contemp: ~25%
* GC content - good
*  Alb: 40-50%, Contemp: 40%
* passing filter - good
  * Alb: >95%, Contemp: >98%
* % adapter - terrible
  * Alb: 50-70%, Contemp: ~25%
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

Looked at fastqc screen results and looks fine. Albatross has more contamination than Contemporary, but most reads come back as 'No hits' or 'Hits on multiple genomes'. Albatross have a few single hits to bacteria/protists, but not many.

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

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/fq_fp1_clmp_fp2_fqscrn_repaired/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSS6MZCN5GJ4SA2FOT6YT3ZI7Q).

---
