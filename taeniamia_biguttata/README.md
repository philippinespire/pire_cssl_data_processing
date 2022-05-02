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

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_biguttata/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSSLOQKIPCM3IRBSXOSYTO52BQ).

Potential issues:  
* % duplication - high acros the board, especially in Albatross
  * Alb: ~90%, Contemp: ~70%
* GC content - okay
  * Alb: 45%, Contemp: 40%
* number of reads - concerning
  * Alb: most <6 mil (very few 10-20 mil), Contemp: ~15-30 mil

## Step 2. 1st fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_biguttata

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture fq_fp1
```
