# Generic Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *spp* samples.

---

## Step 0. Rename files for dDocent HPC

Raw data in `<full path to raw data on Wahab>` (check `<spp>` channel on Slack). Starting analyses in `<full path to species dir>`.

Used decode file from Sharon Magnuson & Chris Bird.

```bash
cd YOUR_SPECIES_DIR/raw_fq_capture

salloc
bash

#check got back sequencing data for all individuals in decode file
ls | wc -l #XX files (2 additional files for README & decode.tsv = XX/2 = XX individuals (R&F)
wc -l NAMEOFDECODEFILE.tsv #XX lines (1 additional line for header = XX individuals), checks out

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv rename
```

---

## Step 1.  Check data quality with fastqc

```sh
cd YOUR_SPECIES_DIR/raw_fq_capture

#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "YOUR_SPECIES_DIR/raw_fq_capture" "fq.gz"
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: XX%, Contemp: XX%
  * GC content - 
    * Alb: XX%, Contemp: XX%
  * number of reads - 
    * Alb: XX mil, Contemp: XX mil

---

## Step 2. 1st fastp

```sh
cd YOUR_SPECIES_DIR

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch raw_fq_capture fq_fp1
```

[Report](URL for your report)

Potential issues:  
  * % duplication - 
    * Alb: XX%, Contemp: XX%
  * GC content -
    * Alb: XX%, Contemp: XX%
  * passing filter - 
    * Alb: XX%, Contemp: XX%
  * % adapter - 
    * Alb: XX%, Contemp: XX%
  * number of reads - 
    * Alb: XX mil, Contemp: XX mil

---

## Step 3. Clumpify

```sh
cd YOUR_SPECIES_DIR

#runCLUMPIFY_r1r2_array.bash <indir;fast1 files > <outdir> <tempdir> <max # of nodes to use at once>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/USERNAME 10
```

Ran `checkClumpify_EG.R` to see if any failed.

```sh
cd YOUR_SPECIES_DIR

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

```sh
cd YOUR_SPECIES_DIR

#runFASTP_2_cssl.sbatch <INDIR/full path to clumpified files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: XX%, Contemp: XX%
  * GC content - 
    *  Alb: XX%, Contemp: XX%
  * passing filter - 
    * Alb: XX%, Contemp: XX%
  * % adapter - 
    * Alb: XX%, Contemp: XX%
  * number of reads - 
    * Alb: XX mil, Contemp: XX mil

---

## Step 5. Run fastq_screen

```sh
cd YOUR_SPECIES_DIR

#runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```

Checked that all files were successfully completed.

```sh
cd YOUR_SPECIES_DIR

#checked that all 5 output files from fastqc screen were created for each file (should be XX for each = XX R1 & XX R2)
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l #XX
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l #XX 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l #XX
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l #XX
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l #XX

#checked all out files for any errors
grep 'error' slurm-fqscrn.*out #nothing
grep 'No reads in' slurm-fqscrn.*out #nothing
```

Everything looks good, no errors/missing files.

Ran `MultiQC` separately.

```sh
cd YOUR_SPECIES_DIR

#runMULTIQC.sbatch <indir> <report name>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report
```

[Report](URL for your report).

Potential issues:

  * one hit, one genome, no ID - 
    * Alb: XX%, Contemp: XX%
  * no one hit, one genome to any potential contaminators (bacteria, virus, human, etc) - 
    * Alb: XX%, Contemp: XX%

---

## Step 6. Repair fastq_screen paired end files

```sh
cd YOUR_SPECIES_DIR

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Once finished, ran `FastQC-MultiQC` to assess quality.

```sh
cd YOUR_SPECIES_DIR

#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "YOUR_SPECIES_DIR/fq_fp1_clmp_fp2_fqscrn_repaired"
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: XX%, Contemp: XX%
  * GC content - 
    * Alb: XX%, Contemp: XX%
  * number of reads - 
    * Alb: XX mil, Contemp: XX mil

---

## Step 7. Calculate the percent of reads lost in each step

Executed `read_calculator_cssl.sh`.

```
cd YOUR_SPECIES_DIR

#read_calculator_cssl.sh "<Path to species home dir>" "<Path to dir with species raw files>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_cssl.sh "YOUR_SPECIES_DIR" "PATH_TO_DIR_WITH_RAW_FILES"
```

Generated the [percent_read_loss](URL for read loss table) and [percent_reads_remaining](URL for read remain table) tables.

Reads lost:

  * fastp1 dropped XX% of the reads
  * XX% of reads were duplicates and were dropped by Clumpify
  * fastp2 dropped XX% of the reads after deduplication

Reads remaining:

Total reads remaining: XX%

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
#if you haven't already, you first need to clone the dDocentHPC.git repo
#cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
#git clone https://github.com/cbirdlab/dDocentHPC.git

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
