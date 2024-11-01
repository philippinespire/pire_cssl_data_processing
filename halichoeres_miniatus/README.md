# Generic Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *spp* samples.

---

## Step 0. Rename files for dDocent HPC

Raw data in `<full path to raw data on Wahab>` (check `<spp>` channel on Slack). Starting analyses in `<full path to species dir>`.

Used decode file from Sharon Magnuson & Chris Bird.

```bash
cd home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture

salloc
bash

#check got back sequencing data for all individuals in decode file
ls | wc -l #374 files (2 additional files for README & decode.tsv = XX/2 = XX individuals (R&F)
wc -l Hmi_CaptureLibraries_SequenceNameDecode.tsv #187 lines (1 additional line for header = XX individuals), checks out

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture/renameFQGZc.bash Hmi_CaptureLibraries_SequenceNameDecode.tsv

#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture/renameFQGZc.bash Hmi_CaptureLibraries_SequenceNameDecode.tsv rename

```

---

## Step 1.  Check data quality with fastqc

Ran [`Multi_FASTQC.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh).

```sh
cd home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture

#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture" "fq.gz"
```
Some samples stalled using the above code including all CPar, some select CBas, and ABas_026. Had to rerun the samples using the Single_FASTQC_noparallel script. 
```
#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture" "<single unrun sample>"
```

All were able to successfully run.
Ran Multiqc again using the runMultiQC script

```sh
cd home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture

#sbatch runMULTIQC.sbatch <indir; fqscreen files> <report name>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture" multiqc_report
```


[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: 93.81%, Contemp: 93.03%
  * GC content - 
    * Alb: 47%, Contemp: 45%
  * number of reads - 
    * Alb: ~20 mil, Contemp: ~0.05 mil

Hardly any reads for the Contemp samples as compared to Alb.

---

## Step 2. 1st fastp

Ran [`runFASTP_1st_trim.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_1st_trim.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture fq_fp1
```

[Report](URL for your report)

Potential issues:  
  * % duplication - 
    * Alb: 92.90%, Contemp: 87.62%
  * GC content -
    * Alb: 45.94%, Contemp: 43.76%
  * passing filter - 
    * Alb: 99%, Contemp: 98%
  * % adapter - 
    * Alb: 60.47%, Contemp: 52.44%
  * number of reads - 
    * Alb: ~57-60 mil, Contemp: ~0.45-0.5 mil

---

## Step 3. Clumpify

Ran [`runCLUMPIFY_r1r2_array.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runCLUMPIFY_r1r2_array.bash).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#runCLUMPIFY_r1r2_array.bash <indir;fast1 files > <outdir> <tempdir> <max # of nodes to use at once>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/mmalabag 10
```

Ran [`checkClumpify_EG.R`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/checkClumpify_EG.R) to see if any failed.

```sh
cd home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

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

Ran [`runFASTP_2_cssl.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFASTP_2_cssl.sbatch).

```sh
cd home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#runFASTP_2_cssl.sbatch <INDIR/full path to clumpified files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: 46.29%, Contemp: 40.28%
  * GC content - 
    *  Alb: 46.81%, Contemp: 44.20%
  * passing filter - 
    * Alb: 97.25%, Contemp: 96.74%
  * % adapter - 
    * Alb: 2.35%, Contemp: 2.44%
  * number of reads - 
    * Alb: ~5.5 mil, Contemp: ~0.40 mil

---

## Step 5. Run fastq_screen

Ran [`runFQSCRN_6.bash`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runFQSCRN_6.bash).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#runFQSCRN_6.bash <indir> <outdir> <number of nodes running simultaneously>
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```
One sample seemed to never be completed (Hmi-ABas_032-Ex1-08C.clmp.fp2_r1), so I reran and included the missing data into the fq_fp1_clmp_fp2_fqscrn directory. 
Checked that all files were successfully completed.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#checked that all 5 output files from fastqc screen were created for each file (should be XX for each = XX R1 & XX R2)
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l #374
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l #374
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l #374
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l #374
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l #374

#checked all out files for any errors
grep 'error' slurm-fqscrn.*out #nothing
grep 'No reads in' slurm-fqscrn.*out #nothing
```

Everything looks good, no errors/missing files.

Ran [`runMultiQC.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runMULTIQC.sbatch) separately.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#runMULTIQC.sbatch <indir> <report name>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report
```

[Report](URL for your report).

Potential issues:

  * one hit, one genome, no ID - 
    * Alb: 83%, Contemp: 87%
  * no one hit, one genome to any potential contaminators (bacteria, virus, human, etc) - 
    * Alb: 2.2%, Contemp: 2%

---

## Step 6. Repair fastq_screen paired end files

Ran [`runREPAIR.sbatch`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/runREPAIR.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_procesing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Once finished, ran [`Multi_FASTQC.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh) to assess quality.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#Multi_FastQC.sh "<indir>" "<file_extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/fq_fp1_clmp_fp2_fqscrn_repaired/" "fq.gz" 
```

[Report](URL for your report).

Potential issues:  
  * % duplication - 
    * Alb: 42.29%, Contemp:  49.81%
  * GC content - 
    * Alb: 46%, Contemp: 43%
  * number of reads - 
    * Alb: ~2.5 mil, Contemp: ~20 k
    * Some reads for contemp had higher number of reads such as CPar_035: ~4-5 mil, CPar_002: ~1 mil, & CPar_027: ~1 mil  

---

## Step 7. Calculate the percent of reads lost in each step

Executed [`read_calculator_cssl.sh`](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/read_calculator_cssl.sh).

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

#read_calculator_cssl.sh "<Path to species home dir>" "<Path to dir with species raw files>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_cssl.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus" "raw_fq_capture"
```

Generated the [percent_read_loss](URL for read loss table) and [percent_reads_remaining](URL for read remain table) tables.

Reads lost:

  * fastp1 dropped 1.69% of the reads
  * 89.57% of reads were duplicates and were dropped by Clumpify
  * fastp2 dropped 3.01% of the reads after deduplication

Reads remaining:

Total reads remaining: 8.14%

---

## Step 8. Set up mapping dir and get reference genome

Make mapping directory and move `*fq.gz` files over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus
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

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM

cp ../../scripts/dDocentHPC/configs/config.5.cssl .
```

Found the best genome by running `wrangleData.R`, sorted tibble by busco single copy complete, quast n50, and filtered by species in Rstudio. The best genome to map to for *spp* is: `<BEST_ASSEMBLY.fasta>` in `<PATH TO DIR WITH BEST GENOME ASSEMBLY`. Copied this to `mkBAM`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM

cp /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_ssl_data_processing/halichoeres_miniatus/SPAdes_HmC0451B_decontam_R1R2_noIsolate/scaffolds.fasta 

#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv scaffolds.fasta  ./reference.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.fasta
```

Updated the config file with the ref genome info.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM

nano config.5.cssl
```

Inserted `<assembly type>` into the `Cutoff1` variable and `<unique assembly info>` into the `Cutoff2` variable.

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
ssl               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
Hmi-C-0451B-R1R2-contam-noIsolate              Cutoff2 (integer)
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
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../../dDocentHPC.sbatch config.5.cssl
```
---
## Generate Mapping Stats for Capture Targets with [`getBAITcvg.sbatch`]

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

# getBAITcvg.sbatch <Path to BAM file dir> <path to bedfile>
sbatch ../scripts/getBAITcvg.sbatch ./mkBAM /home/e1garcia/shotgun_PIRE/pire_probe_sets/16_Halichoeres_miniatus/Baits_chosen.singleLine.bed
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

cd pire_cssl_data_processing/halichoeres_miniatus
mkdir filterVCF
cd filterVCF

cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/filterVCF

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to the second 07 filter (remove filters 18 & 17 from list of filters to run)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl

#troubleshooting will be necessary
```

After looking at the results, it was decided to also run filterVCF two more times: one time just Alb and the other just Contemp. The vcf file was copied and split for the appropriate runs.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/filterVCF

module load vcftools

#Run with just Albatross
vcftools --vcf ../mkBAM/TotalRawSNPs.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf --keep indivALB.txt --recode --recode-INFO-all --out TotalRawSNPs.onlyALB.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf

#Run with just Contemporary
vcftools --vcf ../mkBAM/TotalRawSNPs.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf --keep indivCONTEMP.txt --recode --recode-INFO-all --out TotalRawSNPs.onlyCONTEMP.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf

#Config files were copied and updated to include the appropriate vcf file for each specific run
fltrVCF -v ../filterVCF/TotalRawSNPs.onlyALB.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf.recode.vcf            #vcf file to filter for ALBATROSS

fltrVCF -v ../filterVCF/TotalRawSNPs.onlyCONTEMP.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf.recode.vcf            #vcf file to filter for CONTEMPORARY

#Run filterVCF 
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.Alb #For ALBATROSS

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.Contemp #For CONTEMPORARY
```

Due to lack of sufficient contemporary data, we proceeded with just the Albatross samples with the original config settings.

---

## Step 11. Check for cryptic species

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
#will be from the SECOND 07 filter
cp ../filterVCF/Hmi.A.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.Fltr07.18.vcf .

#There were too many "_" in sample ID names. This was rectified manually by editing the VCF using nano as there was issues with bcftools reading the VCF file. 
```

Ran PCA w/PLINK. Instructions for installing PLINK with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/pop_structure

module load anaconda
conda activate popgen

#VCF file has split chromosome, so running PCA from bed file
plink --vcf Hmi.A.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.Fltr07.18.vcf --allow-extra-chr --make-bed --out PIRE.Hmi.Bas.preHWE
plink --pca --allow-extra-chr --bfile PIRE.Hmi.Bas.preHWE --out PIRE.Hmi.Bas.preHWE
conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/pop_structure

module load anaconda
conda activate popgen

#bed and bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Hmi.Bas.preHWE.bim > PIRE.Hmi.Bas.preHWE.bim.tmp
mv PIRE.Hmi.Bas.preHWE.bim.tmp PIRE.Hmi.Bas.preHWE.bim
conda deactivate
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Hmi.Bas.preHWE.bed 1 --cv > PIRE.Hmi.Bas.preHWE.log1.out #run from 1-5
conda deactivate
```

Copied `*.eigenval`, `*.eigenvec` & `*.Q` files to local computer. Ran `pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R` on local computer to visualize PCA & ADMIXTURE results (figures in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/pop_structure`).

---

## Step 12. Filter VCF file for HWE

**NOTE:** If PCA & ADMIXTURE results don't show cryptic structure, skip to running `fltrVCF.sbatch`.

No evidence for cyrptic species. Proceeded to next step.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/filterVCF/AlbIndiv.only
cp ../mkBAM/popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate  ./popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.HWEsplit #to make it more uniform

```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/filterVCF/AlbIndiv.only
cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)
```
Make a copy of the config.fltr.ind.cssl file called config.fltr.ind.cssl.HWE with file paths and file extensions based on your species AND the new HWEsplit popmap (if applicable). The VCF path should point to the VCF made at the end of the previous filtering run (the file PCA & ADMIXTURE was run with). Remove any filters that aren't run in this step (from the fltrVCF -f line). You will only run filters 18 & 17 (in that order).
```sh
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 18 17                                                                     # order to run filters in
        fltrVCF -c ssl.Hmi-C-0451B-R1R2-contam-noIsolate                                     # cutoffs, ie ref description
        fltrVCF -b ../../mkBAM                                                               # path to *.bam files
        fltrVCF -R ../../../scripts/fltrVCF/scripts                                          # path to fltrVCF R scripts
        fltrVCF -d ../../mkBAM/mapped.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.bed              # bed file used in genotyping
        fltrVCF -v Hmi.A.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.Fltr07.18.vcf                 # vcf file to filter
        fltrVCF -g ../../mkBAM/reference.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.fasta         # reference genome
        fltrVCF -p popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.HWEsplit                     # popmap file
        fltrVCF -w ../../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                         # path to HWE filter script
        fltrVCF -r ../../../scripts/rad_haplotyper/rad_haplotyper.pl                         # path to rad_haplotyper script
        fltrVCF -o Hmi.A                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.HWE
```

---

## Step 13. Make VCF with Monomorphic Loci

Moved the files needed for genotyping from `mkBAM` to `mkVCF`

```sh
#run in scratch if need more space
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus

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
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic

mv config.5.cssl config.5.cssl.monomrphic
```

Genotyped with [dDoceentHPC_mkVCF.sbatch](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC_mkVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic

sbatch dDocentHPC.sbatch config.5.cssl.monomorphic #copied dDocentHPC.sbatch to edit and create only VCF files
```

---

## Step 14. Filter VCF with monomorphic loci

Will filter for monomorphic & polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, probably best to do this in scratch.

Set-up filtering for monomorphic sites only.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic

cp ../../scripts/config.fltr.ind.cssl.mono .
```
Update the `config.fltr.ind.cssl.mono` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made. **The settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file.**


```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 04 14 05 16 04 13 05 16 17                                                                                                    # order to run filters in
        fltrVCF -c ssl.Hmi-C-0451B-R1R2-contam-noIsolate                                                                                               # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic                                        # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                                       # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM/mapped.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.bed   # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic/TotalRawSNPs.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf      # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic/reference.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.fasta      # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM/popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.edited        # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Hmi.mono                                                                                                        # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                        # number of threads [1]

```
Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for monomorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.mono 

```

Set-up filtering for polymorphic sites only.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic

mkdir polymorphic_filter
cd polymorphic_filter

cp ../../../scripts/config.fltr.ind.cssl.poly .
```
Update the `config.fltr.ind.cssl.poly` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made AND the HWEsplit popmap you made if you had any cryptic population structure. **The settings for all your filters should match the settings used when filtering the original VCF file.**

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07 18 17                                                                                             # order to run filters in
        fltrVCF -c ssl.Hmi-C-0451B-R1R2-contam-noIsolate                                                                                                                   # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic                                                            # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                                                           # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkBAM/mapped.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.bed                       # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic/TotalRawSNPs.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.vcf     # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic/reference.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.fasta      # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/filterVCF/AlbIndiv.only/popmap.ssl.Hmi-C-0451B-R1R2-contam-noIsolate.HWEsplit    # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                                                          # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                                                          # path to rad_haplotyper script
        fltrVCF -o Hmi.poly                                                                                                                                                # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                                                      # number of threads [1]
```

Ran [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for polymorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#popmap file should be file used in step 12, that accounts for any cryptic structure (*HWEsplit extension)
#settings should match the settings used when filtering the original VCF file (step 10)
sbatch ../../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.poly 

```

However, because only Alb individuals were taken, there was not enough information. Running the previous code resulted in empty polymorphic files. Therefore, the proceeding steps could not run. 
