# Leq Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Leiognathus equula* samples.

---

## Step 0.  Rename files for dDocent HPC

Raw data in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture` (check Leiognathus-equula channel on Slack).  Starting analyses in  `/home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula`.

Used decode file from Sharon Magnuson & Chris Bird.

```
salloc
bash

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture

#check got back sequencing data for all individuals in decode file
ls | wc -l #230 files (2 additional files for README & decode.tsv = 228/2 = 114 individuals (R&F)
wc -l Tbi_CaptureLibraries_SequenceNameDecode.tsv #117 lines (1 additional line for header = 116 individuals), does NOT match
```

Looks like missing sequencing data for two individuals:
  1. LEC01034 --> (Leq-CMig_034-Ex1)
  2. LEC01061 --> (Leq-CMig_061-Ex1)

Also noticed we have the same individual (ABas_013) twice (sequencing data from two different extractions): LeA01131 (Leq-ABas_013_Ex1-1) & LeA01132 (Leq-ABas_013-Ex1-2)

Moving forward with renaming.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Leq_CaptureLibraries_SequenceNameDecode.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Leq_CaptureLibraries_SequenceNameDecode.tsv rename

cp *FileNames.txt /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture
```

## Step 1.  Check data quality with fastqc

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture"

#once finished
mkdir /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula/Multi_FASTQC
mv /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/Multi_FASTQC/* /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula/Multi_FASTQC
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/leiognathus_equula/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSSPD7WMZ7Q5ECII67SYTO6YWQ).

Potential issues:  
* % duplication - fine
  * Alb: ~40%, Contemp: ~50%
* GC content - okay
  * Alb: 50%, Contemp: 45%
* number of reads - concerning
  * Alb: ~half <10 mil & ~half 15-30 mil, Contemp: ~5-10 mil

## Step 3. 1st fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/leiognathus_equula

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture fq_fp1
```
