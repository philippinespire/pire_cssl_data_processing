# Tzo Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Taeniamia zosterophera* samples.

---

## Step 0.  Rename files for dDocent HPC

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

Copied raw (renamed) `*fq.gz` files to the longterm Carpenter RC directory.

```
cd /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing
mkdir taeniamia_zosterophora

cd taeniamia_zosterophora
mkdir fq_raw_cssl

cp /home/e1garica/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture/* fq_raw_cssl/
```

---

## Step 1.  Check data quality with fastqc

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture"

#once finished
mkdir /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora/Multi_FASTQC
mv /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/Multi_FASTQC/* /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora/Multi_FASTQC
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_zosterophora/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSSKNXD5USFDMN56UWGYTP7R3Q).

Potential issues:  
* % duplication - high acros the board, especially in Albatross
  * Alb: ~90%, Contemp: ~75-80%
* GC content - good
  * Alb: 40%, Contemp: 40%
* number of reads - mostly fine
  * Alb: generally higher # (>30 mil), Contemp: ~10-20 mil, a few <10 mil

---

## Step 2. 1st fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture fq_fp1
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_zosterophora/fq_fp1/1st_fastp_report.html?token=GHSAT0AAAAAABQHSGSSVAOFRXD6IXELATXOYTP7S2A)

Potential issues:  
* % duplication - still very high acros the board
  * Alb: ~90%, Contemp: ~75-80%
* GC content - good
  * Alb: 38-40%, Contemp: 45%
* passing filter - great
  * Alb: >99%, Contemp: >98%
* % adapter - high for Albatross, low for Contemp
  * Alb: >70%, Contemp: 10-20%
* number of reads - seems to be okay
  * Alb: generally much higher # (>30 mil), Contemp: ~10-20 mil w/some pretty low

---

## Step 3. Clumpify

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora

#runCLUMPIFY_r1r2_array.bash <indir;fast1 files > <outdir> <tempdir> <max # of nodes to use at once>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/r3clark 10
```

Ran `checkClumpify.R` to see if any failed.

```
cd /scratch/r3clark/taeniamia_zosterophora

salloc
module load container_env mapdamage2

#had to install tidyverse package first
crun R
install.packages("tidyverse") #said yes when prompted, when finished, exited & didn't save env

crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save
#all files ran successfully
```

---

## Step 4. 2nd fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora

#runFASTP_2_cssl.sbatch <INDIR/full path to clumpified files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_zosterophora/fq_fp1_clmp_fp2/2nd_fastp_report.html?token=GHSAT0AAAAAABQHSGSTLRUWEBLSVQD6DGMGYT5IDGA).

Potential issues:  
* % duplication - still high?
  * Alb: ~50%, Contemp: ~40%
* GC content - good
*  Alb: 35-40%, Contemp: 40%
* passing filter - great
  * Alb: >98%, Contemp: >99%
* % adapter - great
  * Alb: <2%, Contemp: <1%
* number of reads - took a big hit, especially Albatross
  * Alb: 5-10 mil, Contemp: 1-8 mil

---

## Step 5. Run fastq_screen

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora

#runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```

Checked that all files were successfully completed.

```
cd /scratch/r3clark/taeniamia_zosterophora

#checked that all 5 output files from fastqc screen were created for each file (should be 206 for each = 103 R1 & 103 R2)
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l #206
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l #206 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l #206
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l #206
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l #206

#checked all out files for any errors
grep 'error' slurm-fqscrn.*out #nothing
grep 'No reads in' slurm-fqscrn.*out #nothing
```

Everything looks good, no errors/missing files.

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_zosterophora/fq_fp1_clmp_fp2_fqscrn/fqscrn_mqc.html?token=GHSAT0AAAAAABQHSGSTUXQMX7HVKDXLHYQOYT6O7IA).

Albatross has more contamination than Contemporary, but most reads come back as 'No hits' or 'Hits on multiple genomes'. Albatross have a few single hits to bacteria/protists, but not many.

---

## Step 6. Repair fastq_screen paired end files

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Once finished, ran multiqc to assess quality.

```
cd /scratch/r3clark/taeniamia_zosterophora

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/scratch/r3clark/taeniamia_zosterophora/fq_fp1_clmp_fp2_fqscrn_repaired"
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/taeniamia_zosterophora/fq_fp1_clmp_fp2_fqscrn_repaired/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSTTW2M7L3O6MUPO5KGYT6SLGA).

---

## Step 7. Calculate the percent of reads lost in each step

Executed `read_calculator_cssl.sh`. Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora

#read_calculator_cssl.sh <Path to species home dir> <Path to dir with species raw files>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_cssl.sh "/scratch/r3clark/taeniamia_zosterophora" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora"
```

Inspected these tables to see where most of the data was lost. Most data (~70-90%) lost during clumpify step, which makes sense (expect high level of duplication).

---

## Step 8. Set up mapping dir and get reference genome

Make mapping directory and move `*fq.gz` files over. Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/taeniamia_zosterophora/
mkdir mkBAM

mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAM
```

Pulled latest changes from dDocentHPC repo & copied `config.5.cssl` over.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts/dDocentHPC
git pull

cd /scratch/r3clark/taeniamia_zosterophora/mkBAM

cp /home/r3clark/PIRE/pire_cssl_data_processing/scripts/dDocentHPC/configs/config.5.cssl .
```

Found the best genome by running `wrangleData.R`, sorted tibble by busco single copy complete, quast n50, and filtered by species in Rstudio. The best genome to map to for *Taeniamia zosterophora* is: **Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta** in `/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/taeniamia_zosterophora/probe_design`. Copied this to `mkBAM`.

```
cd /scratch/r3clark/taeniamia_zosterophora/mkBAM

cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/taeniamia_zosterophora/probe_design/Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta .

#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta ./reference.ssl.Tzo-C-0402G-R1R2-contam-noisolate.fasta
```

Updated the config file with the ref genome info.

```
cd /scratch/r3clark/taeniamia_zosterophora/mkBAM
nano config.5.cssl
```

Inserted `<assembly type>` into the `Cutoff1` variable and `<unique assembly info>` into the `Cutoff2` variable.

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
ssl               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
Tzo-C-0402G-R1R2-contam-noisolate               Cutoff2 (integer)
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
cd /scratch/r3clark/taeniamia_zosterophora/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../dDocentHPC.sbatch config.5.cssl
```

Handing off to Kyra Fitz for further processing.

---
