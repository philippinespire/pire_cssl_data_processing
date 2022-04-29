# Tzo Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Taeniamia zosterophera* samples.

---

## Step 1.  Rename files for dDocent HPC

Raw data in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture` (check Taeniamia-zosterophora channel on Slack).  Starting analyses in  `/home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora`.

Used decode file from Sharon Magnuson & Chris Bird.

```
salloc
bash

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture

#check got back sequencing data for all individuals in decode file
ls | wc -l #208 files (2 additional files for README & decode.tsv = 206/2 = 103 individuals (R&F)
wc -l Tzo_CaptureLibraries_SequenceNameDecode.tsv #104 lines (1 additional line for header = 103 individuals), checks out

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Tzo_CaptureLibraries_SequenceNameDecode.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Tzo_CaptureLibraries_SequenceNameDecode.tsv rename

cp *FileNames.txt /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture
```

## Step 2.  Check data quality with fastqc

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture"

#once finished
mkdir /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora/Multi_FASTQC
mv /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/Multi_FASTQC/* /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora/Multi_FASTQC
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_zosterophora/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSSG5SLW2K6TTV7RSJQYTMIX2Q), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

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
