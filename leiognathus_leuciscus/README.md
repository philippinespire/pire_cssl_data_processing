# Generic Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *spp* samples.

---

## Step 0. Rename files for dDocent HPC

Raw data in `<full path to raw data on Wahab>` (check `<spp>` channel on Slack). Starting analyses in `<full path to species dir>`.

Used decode file from Sharon Magnuson & Chris Bird.

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/raw_fq_capture

salloc
bash

#check got back sequencing data for all individuals in decode file
ls | wc -l #256 files (2 additional files for README & decode.tsv = XX/2 = XX individuals (R&F)
wc -l Lle_CaptureLibraries_SequenceNameDecode_fixed.tsv #129 lines (1 additional line for header = XX individuals), checks out

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Lle_CaptureLibraries_SequenceNameDecode_fixed.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Lle_CaptureLibraries_SequenceNameDecode_fixed.tsv rename
```

---

## Step 1.  Check data quality with fastqc

Ran [`Multi_FASTQC.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/raw_fq_capture

#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/raw_fq_capture" "fq.gz"
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: 79.20%, Contemp: 54.65%
  * GC content - 
    * Alb: 46%, Contemp: 47%
  * number of reads - 
    * Alb: ~19 mil, Contemp: ~6 mil

---

## Step 2. 1st fastp

Ran [`runFASTP_1st_trim.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_1st_trim.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch raw_fq_capture fq_fp1
```

[Report](URL for your report)

Potential issues:  
  * % duplication - 
    * Alb: 73.35%, Contemp: 49.06%
  * GC content -
    * Alb: 43.88%, Contemp: 46.16%
  * passing filter - 
    * Alb: 96.52%, Contemp: 95.92%
  * % adapter - 
    * Alb: 85.02%, Contemp: 49.25%
  * number of reads - 
    * Alb: ~31 mil, Contemp: ~8 mil

---

## Step 3. Clumpify

Ran [`runCLUMPIFY_r1r2_array.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runCLUMPIFY_r1r2_array.bash).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#runCLUMPIFY_r1r2_array.bash <indir;fast1 files > <outdir> <tempdir> <max # of nodes to use at once>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/mmalabag 10
```

Ran [`checkClumpify_EG.R`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/checkClumpify_EG.R) to see if any failed.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

salloc
module load container_env mapdamage2

#had to install tidyverse package first
crun R
install.packages("tidyverse") #said yes when prompted, when finished, exited & didn't save env

crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save
#all files ran successfully
```

Ran [`runMULTIQC.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runMULTIQC.sbatch)  to get the MultiQC ouput

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#sbatch Multi_FASTQC.sh "<indir>" "<mqc report name>" "<file extension to qc>"
#do not use trailing / in paths. Example:
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"
```

---

## Step 4. 2nd fastp

Ran [`runFASTP_2_cssl.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_cssl.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#runFASTP_2_cssl.sbatch <INDIR/full path to clumpified files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: 24.17%, Contemp: 12.42%
  * GC content - 
    *  Alb: 45%, Contemp: 46.51%
  * passing filter - 
    * Alb: 97.88%, Contemp: 99.00%
  * % adapter - 
    * Alb: 2.74%, Contemp: 0.88%
  * number of reads - 
    * Alb: ~7 mil, Contemp: ~4.5 mil

---

## Step 5. Run fastq_screen

Ran [`runFQSCRN_6.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```
Some files didn't run (either due to storage problems or general errors) so I had to rerun them individually, to success.

```sh
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_089.clmp.fp2_r2.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_092.clmp.fp2_r1.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_092.clmp.fp2_r2.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_093.clmp.fp2_r2.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_094.clmp.fp2_r1.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_094.clmp.fp2_r2.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_095.clmp.fp2_r2.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_096.clmp.fp2_r1.fq.gz
bash ../pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Lle-CNas_096.clmp.fp2_r2.fq.gz
```

Checked that all files were successfully completed.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#checked that all 5 output files from fastqc screen were created for each file (should be XX for each = XX R1 & XX R2)
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l #256
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l #256 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l #256
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l #256
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l #256

#checked all out files for any errors
grep 'error' slurm-fqscrn.*out #nothing
grep 'No reads in' slurm-fqscrn.*out #nothing
```

Everything looks good, no errors/missing files.

Ran [`runMultiQC.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runMULTIQC.sbatch) separately.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#runMULTIQC.sbatch <indir> <report name>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report
```

[Report](URL for your report).

Potential issues:

  * one hit, one genome, no ID - 
    * Alb: 85%, Contemp: 90%
  * no one hit, one genome to any potential contaminators (bacteria, virus, human, etc) - 
    * Alb: 4%, Contemp: 2%

---

## Step 6. Repair fastq_screen paired end files

Ran [`runREPAIR.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Once finished, ran [`Multi_FASTQC.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh) to assess quality.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh ".../leiognathus_leuciscus/fq_fp1_clmp_fp2_fqscrn_repaired" "fqc_rprd_report" "fq.gz"

# check to be sure the job is running
watch squeue -u mmalabag
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: 22.33%, Contemp: 13.17%
  * GC content - 
    * Alb: 44%, Contemp: 45%
  * number of reads - 
    * Alb: ~3.5 mil, Contemp: ~2 mil

---

## Step 7. Calculate the percent of reads lost in each step

Executed [`read_calculator_cssl.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/read_calculator_cssl.sh).

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

#read_calculator_cssl.sh "<Path to species home dir>" "<Path to dir with species raw files>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus" "raw_fq_capture"
```

Generated the [percent_read_loss](URL for read loss table) and [percent_reads_remaining](URL for read remain table) tables.

Reads lost:

  * fastp1 dropped 3.93% of the reads
  * 58.46% of reads were duplicates and were dropped by Clumpify
  * fastp2 dropped 1.28% of the reads after deduplication

Reads remaining:

Total reads remaining: 34.56%

---

## Step 8. Set up mapping dir and get reference genome

Make mapping directory and move `*fq.gz` files over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus
mkdir mkBAM

mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAM
```

Pulled latest changes from dDocentHPC repo & copied `config.5.cssl` over.

```sh
#if you haven't already, you first need to clone the dDocentHPC.git repo
#cd pire_cssl_data_processing/scripts
#git clone https://github.com/cbirdlab/dDocentHPC.git

#if you have cloned, just pull the latest changes
cd /pire_cssl_data_procesing/scripts/dDocentHPC
git pull

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM

cp ../../scripts/dDocentHPC/configs/config.5.cssl .
```

Found the best genome by running `wrangleData.R`, sorted tibble by busco single copy complete, quast n50, and filtered by species in Rstudio. The best genome to map to for *spp* is: `<BEST_ASSEMBLY.fasta>` in `<PATH TO DIR WITH BEST GENOME ASSEMBLY`. Copied this to `mkBAM`. Best genome had to be extracted from out_Lle-C_3NR_R1R2ORPH_contam_noisolate_covcutoff-off.tar.gz and was placed in main lle_spades directory for easy access.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM

cp /home/e1garcia/shotgun_PIRE/lle_spades/scaffolds.fasta .

#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv scaffolds.fasta ./reference.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.fasta
```

Updated the config file with the ref genome info.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM

nano config.5.cssl
```

Inserted `<assembly type>` into the `Cutoff1` variable and `<unique assembly info>` into the `Cutoff2` variable.

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
ssl               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
Lle-C-3NR-R1R2ORPH-contam-noIsolate              Cutoff2 (integer)
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

Ran [`dDocentHPC.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkBAM config.5.cssl    #make BAM files
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch fltrBAM config.5.cssl  #filter BAM files
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.5.cssl    #make VCF files
```

---
## Generate Mapping Stats for Capture Targets with [`getBAITcvg.sbatch`]

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

# getBAITcvg.sbatch <Path to BAM file dir> <path to bedfile>
sbatch ../scripts/getBAITcvg.sbatch ./mkBAM /home/e1garcia/shotgun_PIRE/pire_probe_sets/07_Leiognathus_leuciscus/Leiognathus_leuciscus_Chosen_baits.singleLine.bed
```

---

## Step 10. Filter VCF File

Pulled latest changes from fltrVCF and rad_haplotyper repos.

```sh
#if you haven't already, you first need to clone the fltrVCF.git repo & the rad_haplotyper.git repo
#cd pire_cssl_data_processing/scripts
#git clone https://github.com/cbirdlab/fltrVCF.git
#git clone https://github.com/cbirdlab/rad_haplotyper.git

cd pire_cssl_data_processing/scripts/fltrVCF
git pull

cd pire_cssl_data_processing/scripts/rad_haplotyper
git pull

cd pire_cssl_data_processing/leiognathus_leuciscus
mkdir filterVCF
cd filterVCF

cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to the second 07 filter (remove filters 18 & 17 from list of filters to run)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl

#troubleshooting will be necessary
```

---

## Step 11. Check for cryptic species

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
#will be from the SECOND 07 filter
cp ../filterVCF/Lle.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr07.18.vcf .

#There were too many "_" in sample ID names. This was rectified manually by editing the VCF using nano as there was issues with bcftools reading the VCF file. 
```

Ran PCA w/PLINK. Instructions for installing PLINK with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure

module load anaconda
conda activate popgen

#VCF file has split chromosome, so running PCA from bed file
plink --vcf Lle.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr07.18.vcf --allow-extra-chr --make-bed --out PIRE.Lle.Ham.preHWE
plink  --pca --allow-extra-chr --bfile PIRE.Lle.Ham.preHWE --out PIRE.Lle.Ham.preHWE
conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure

module load anaconda
conda activate popgen

#bed and bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Lle.Ham.preHWE.bim > PIRE.Lle.Ham.preHWE.bim.tmp
mv PIRE.Lle.Ham.preHWE.bim.tmp PIRE.Lle.Ham.preHWE.bim
conda deactivate
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Lle.Ham.preHWE.bed 1 --cv > PIRE.Lle.Ham.preHWE.log1.out #run from 1-5
conda deactivate
```

Copied `*.eigenval`, `*.eigenvec` & `*.Q` files to local computer. Ran `pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R` on local computer to visualize PCA & ADMIXTURE results (figures in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure`).

---

## Step 12. Filter VCF file for HWE

**NOTE:** If PCA & ADMIXTURE results don't show cryptic structure, skip to running `fltrVCF.sbatch`.

PCA & ADMIXTURE showed cryptic structure. Most samples were assigned group "A" and the remaining were group "B"

Adjusted popmap file to reflect new structure.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF
cp ../mkBAM/popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate ./popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.HWEsplit

#added -A or -B to end of pop assignment (second column) to assign individual to either group A or group B.
```

Copy config for HWE.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF
cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE
```

Edit config. Before running, make sure the config file is updated with file paths and file extensions based on your species. Popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected). Vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with). Config file should ONLY run filters 18 & 17 (in that order)

```sh
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 18 17                                                                     # order to run filters in
        fltrVCF -c ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate                                   # cutoffs, ie ref description
        fltrVCF -b ../mkBAM                                                                  # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
        fltrVCF -d ../mkBAM/mapped.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.bed               # bed file used in genotyping
        fltrVCF -v Lle.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr07.18.vcf               # vcf file to filter
        fltrVCF -g ../mkBAM/reference.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.fasta          # reference genome
        fltrVCF -p popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.HWEsplit                   # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Lle.A                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```
Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF_merge/filterVCF_merge

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.HWE 
```

---

## Step 13. Make VCF with Monomorphic Loci

Moved the files needed for genotyping from `mkBAM` to `mkVCF`

```sh
#run in scratch if need more space
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus

mkdir mKVCF_monomorphic
mv mkBAM/*bam* mkVCF_monomorphic
cp mkBAM/*fasta mkVCF_monomorphic
cp mkBAM/config.5.cssl mkVCF_monomorphic
```

Changed the config file so that the last setting (monomorphic) is set to yes and renamed it with the suffix `.monomorphic`

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles,
```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

mv config.5.cssl config.5.cssl.monomrphic
```

Genotyped with [dDoceentHPC_mkVCF.sbatch](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC_mkVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.5.cssl.monomorphic 
```

---

## Step 14. Filter VCF with monomorphic loci

Will filter for monomorphic & polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, probably best to do this in scratch.

Set-up filtering for monomorphic sites only.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

cp ../../scripts/config.fltr.ind.cssl.mono .
```

Update the `config.fltr.ind.cssl.mono` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made. **The settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file.**

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 04 14 05 16 04 13 05 16 17                  # order to run filters in
        fltrVCF -c ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate                               # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic                                                                  # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                                                                  # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM/mapped.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.bed                           # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic/TotalRawSNPs.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.vcf         # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM/reference.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.fasta                      # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM/popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate                               # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                                                                 # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                                                                 # path to rad_haplotyper script
        fltrVCF -o Lle.mono                                                                                                                                                       # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                                                             # number of threads [1]
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for monomorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file (step 10)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.mono
```

Set-up filtering for polymorphic sites only.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

mkdir polymorphic_filter
cd polymorphic_filter

cp ../../../scripts/config.fltr.ind.cssl.poly .
```

Update the `config.fltr.ind.cssl.poly` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made AND the HWEsplit popmap you made if you had any cryptic population structure. **The settings for all your filters should match the settings used when filtering the original VCF file.**

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07 18 17                                                                                                # order to run filters in
        fltrVCF -c ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate                                                                                                                    # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic                                                              # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                                                              # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM/mapped.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.bed                       # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic/TotalRawSNPs.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.vcf     # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM/reference.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.fasta                  # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF/popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.HWEsplit              # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                                                             # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                                                             # path to rad_haplotyper script
        fltrVCF -o Lle.poly                                                                                                                                                   # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                                                         # number of threads [1]
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for polymorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic/polymorphic_filter

sbatch ../../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.poly 
```

---

## Step 15. Merge monomorphic & polymorphic VCF files

Check monomorphic & polymorphic VCF files to make sure that filtering removed the same individuals. If not, remove necessary individuals from files.

Created `indv_missing.txt` in `mkVCF_monomorphic` directory. This is a list of all the individuals removed from either  file (total of XX for *spp*). Used this list to make sure number of individuals matched in both filtered VCFs.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic
mv polymorphic_filter/Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.vcf . 

module load vcftools

#remove missing individuals in mono
vcftools --vcf Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out  Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.vcf #remove missing indiv
mv Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.vcf.recode.vcf Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.vcf #rename

#remove missing individuals in poly
vcftools --vcf Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.vcf
mv Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.vcf.recode.vcf Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.vcf

```

Sorted each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load vcftools

#sort monomorphic (nomissing VCF)
vcf-sort Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.vcf > Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.sorted.vcf

#sort polymorphic (nomissing VCF)
vcf-sort Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.vcf > Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.sorted.vcf
```

Zipped each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load samtools/1.9

#zip monomorphic
bgzip -c Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.sorted.vcf > Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.sorted.vcf.gz

#zip polymorphic
bgzip -c Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.sorted.vcf > Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Indexed each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load samtools/1.9

#index monomorphic
tabix Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.sorted.vcf.gz

#index polymorphic
tabix Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Merged files.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

bash
export SINGULARITY_BIND=/home/e1garcia

crun bcftools concat --allow-overlaps Lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.11.recode.nomissing.sorted.vcf.gz Lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noIsolate.Fltr17.20.recode.nomissing.sorted.vcf.gz -O z -o Lle.all.recode.nomissing.sorted.vcf.gz
tabix Lle.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses

exit
```
