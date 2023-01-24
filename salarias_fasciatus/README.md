# Sfa CSSL Data Processing Log

Following the [pire_cssl_data_processing](https://github.com/philippinespire/pire_cssl_data_processing) roadmap

and [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing)

## FQ GZ Processing - Renamed files ##
```
#ran the rename script
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture/renameFQGZc.bash Sfa_cssl_SequenceNameDecode_fixed2.tsv rename
```

## FQ GZ Processing - MultiQC ###

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/raw_fq_capture" "fq.gz"
```

## Step 1. Fastqc

Ran the [Multi_FASTQC.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh) script. [Report] ((https://github.com/philippinespire/ PUT THE LINK HERE)

Potential issues:
* % duplication - moderate to high
  * 74.8-80.7% in Albatross
  * 33.4-92% in Contemporary
* gc content - reasonable
  * 42-47%
* quality - good
  * sequence quality and per sequence qual both good
* high adapter content - 152 of 162 failed
* number of reads 
  * Albatross - 5.9-19.8 M; Contemporary - 4-22.6 M


## Step 2.  1st fastp

Locate data location in slack channel for this species to get the indir.  The outdir should be `/home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR`

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
#runFASTP_1.sbatch <indir> <outdir>
# do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/raw_fq_capture fq_fp1
```
[Report]().

Potential issues:  
* % duplication - high for albatross, 
  * alb:70-80, contemp: 31-91, mostly 50s
* gc content - 40%, reasonable
* passing filter - 97% up, very good
* % adapter - high, but that was expected, 
  * alb: 60-80s, contemp: 9-40s
* number of reads - decent
  * generally more for albatross than contemp, as we attempted to do
  * alb: 11-39 M, contemp: 7-24 M
 
---

## Step 2. Clumpify

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
# do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/jbald004 20

#navigated to the fq_fp1_clmp folder to copy checkClumpify_EG.R
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/fq_fp1_clmp
cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/fq_fp1_clmp/checkClumpify_EG.R .
#ran checkClumpify_EG.R
salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2
crun R < checkClumpify_EG.R --no-save

#checked if clumpify ran properly
#since Clumpify was successful,
exit #to relinquish the interactive node
```

## Step 3. Run fastp2

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
#runFASTP_2.sbatch <indir> <outdir> 
# do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```
[Report]().

Potential issues:  
* % duplication - good  
  * alb:24-31, contemp: 9-20, w/ 8 that had 58-60
* gc content - reasonable
  * alb: 40s, contemp: 40s 
* passing filter - good
  * alb: 97+, contemp: 97+s 
* % adapter - good
  * alb: 1, contemp: 0.3-0.5s
* number of reads - lost alot for albatross
  * generally more for albatross than contemp
  * alb: 3-10M, contemp: 2-31M
---

## Step 4. Run fastq_screen

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously>
# do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
# check output for errors
#FastQ Screen generates 5 files (*tagged.fastq.gz, *tagged_filter.fastq.gz, *screen.txt, *screen.png, *screen.html) for each input fq.gz file
#check that all 5 files were created for each file: 
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l
#I had 162 files, but only 161 files were showing up. I wanted to pinpoint which file had failed since I knew there were 162 input files
#do all out files at once
grep 'error' slurm-fqscrn.*out
grep 'No reads in' slurm-fqscrn.*out
#since this didn't return anything, I had to download the list and check using pivot tables on Excel to find which file failed.
```
Sfa-CBas_008-Ex1-cssl.clmp.fp2_r2.fq.gz had missing files so I ran fqscrn on this file only.

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously> <fq file pattern to process>
# do not use trailing / in paths
ash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Sfa-CBas_008-Ex1-cssl.clmp.fp2_r2.fq.gz
```

Re-did the checking. Since there were no errors, and all 162 files were present for each file type, I proceeded with multiqc:
```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report

```
Report is here (insert link): 
* Most sequences no hit
* Multiple genomes & Protists common
* Human DNA common in Albatross samples, with 1 sample having a substantial amount

## Step 5. Repair fastq_screen paired end files

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
# runREPAIR.sbatch <indir> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Run Multi_FASTQC!
```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/fq_fp1_clmp_fp2_fqscrn_repaired" "fq.gz"
```

MultiQC summary (put report here)
* Duplication - Albatross 15-22%, Contemporary 7-11, although there are 7 individuals that had 40-55% duplication
* GC % - 40%, good
* Length - 100-140 (shorter reads w/ Albatross)
* Number of reads - Albatross had 0.1 to 0.4 M, Contemporary had a wide spread from 0.1 to 13 M
* Good sequence quality
---

## Step 6. Calculate % Reads lost
```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_cssl.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus"
```
Tables for readLoss (link) and readsRemaining (link)

Lots of reads lost at clumpify step (de-duplication, makes sense).
More reads lost for Albatross at decontamination.
Still >100k reads for most Albatross, although there still may be contamination based on GC content.
Moving on to CSSL pipeline!

## Step 7.  Mapping & Filtering Data
```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
mkdir mkBAMtest
mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAMtest
```

Clone dDocentHPC config flie
```bash
git clone https://github.com/cbirdlab/dDocentHPC.git
cd mkBAMtest
cp ../dDocentHPC/configs/config.5.cssl .
```

Copied best assembly to mkBAM folder
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/mkBAMtest
cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/salarias_fasciatus/probe_design/Sfa_scaffolds_allLibs_contam_R1R2_noIsolate.fasta .
#rename file
mv Sfa_scaffolds_allLibs_contam_R1R2_noIsolate.fasta reference.ssl.Sfa-scaffolds-allLibs-contam-R1R2-noIsolate.fasta
```

Updated config5.cssl file:
```
ssl               Cutoff1 (integer) 
Sfa-scaffolds-allLibs-contam-R1R2-noIsolate               Cutoff2 (integer)
```

## Step 8. Map reads to reference - Filter Maps - Genotype Maps

Run dDocent - map reads

```bash
cd /home/e1garcia/pire_cssl_data_processing/salarias_fasciatus/mkBAMtest
#this has to be run from dir with fq.gz files to be mapped and the ref genome
# this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/dDocentHPC.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/mkBAM/
# added export SINGULARITY_BIND=/home/e1garcia + correct pathways
sbatch dDocentHPC.sbatch config.5.cssl
```

got an error:
```
Wed Oct 19 05:28:14 EDT 2022 Assembling final VCF file...
[E::hts_idx_push] Chromosome blocks not continuous
tbx_index_build failed: TotalRawSNPs.ssl.Sfa-scaffolds-allLibs-contam-R1R2-noIsolate.vcf.gz
```

So employed the same steps as Brendan who encountered the same error w/ the Siganus spinus dataset.
```
salloc
module load vcftools
module load htslib
vcf-sort TotalRawSNPs.ssl.Sfa-scaffolds-allLibs-contam-R1R2-noIsolate.vcf > TotalRawSNPs.ssl.Sfa-scaffolds-allLibs-contam-R1R2-noIsolate-resort.vcf
bgzip TotalRawSNPs.ssl.Sfa-scaffolds-allLibs-contam-R1R2-noIsolate-resort.vcf
tabix TotalRawSNPs.ssl.Sfa-scaffolds-allLibs-contam-R1R2-noIsolate-resort.vcf.gz
```
Since these steps address the error, I didn't have to run the dDocent sbatch file again. I went ahead and used the scripts written by Chris & Roy for calculating mapping efficiency:
```
cp -r /home/cbird/roy/rroberts_thesis/scripts/bam_processing/ /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/bam_processing
sbatch getCVG.sbatch ../mkBAM out_cvg_SfascaffoldsallLibscontam/
sbatch getCVG.sbatch ../mkBAM_probedevref out_cvg_SfascaffoldsallLibscontam/
sbatch getSTATS.sbatch ../mkBAM out_stats_SfascaffoldsallLibscontam/
sbatch getSTATS.sbatch ../mkBAM_probedevref out_stats_SfascaffoldsallLibscontam/
sbatch mappedReadStats.sbatch ../mkBAM out_ReadStats_SfascaffoldsallLibscontam/ Sfa
sbatch mappedReadStats.sbatch ../mkBAM out_ReadStats_SfascaffoldsallLibscontam/ Sfa
```
---

## Preliminary filter (pre-HWE, before checking for cryptic species)

Clone fltrVCF and rad_haplotyper repos

```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus
git clone git@github.com:cbirdlab/fltrVCF.git
git clone git@github.com:cbirdlab/rad_haplotyper.git
```

```
cd fltrVCF
cp config_files/config.fltr.ind.cssl ./
mv config.fltr.ind.cssl config.fltr.ind.cssl.1
```

Ran `fltrVCF.sbatch`.
```bash
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/salarias_fasciatus/fltrVCF
#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to the second 07 filter (remove filters 18 & 17 from list of filters to run)
sbatch fltrVCF.sbatch config.fltr.ind.cssl.1

```

---

## Step 10. Check for cryptic species

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus
mkdir pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF/*Fltr07.14.vcf pop_structure
```

Ran PCA w/PLINK. Instructions for installing PLINK with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure

module load anaconda
conda activate popgen

#VCF file has split chromosome, so running PCA from bed file 
plink --vcf lle.B.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.14.vcf --allow-extra-chr --make-bed --out PIRE.Lle.Ham.preHWE
plink --pca --allow-extra-chr --bfile PIRE.Lle.Ham.preHWE --out PIRE.Lle.Ham.preHWE
conda deactivate
```

Made input files for ADMIXTURE with PLINK.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure

#bed & bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Lle.Ham.preHWE.bim > PIRE.Lle.Ham.preHWE.bim.tmp
mv PIRE.Lle.Ham.preHWE.bim.tmp PIRE.Lle.Ham.preHWE.bim
```

Ran ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.Lle.Ham.preHWE.bed 1 --cv > PIRE.Lle.Ham.preHWE.log1.out #run from 1-5
conda deactivate
```

Copied `*.eigenval`, `*.eigenvec` & `*.Q` files to local computer. Ran `pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R` on local computer to visualize PCA & ADMIXTURE results (figures in `/home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/pop_structure`).

---

## Step 11. Filter VCF file for HWE

**NOTE:** If PCA & ADMIXTURE results don't show cryptic structure, skip to running `fltrVCF.sbatch`.

PCA & ADMIXTURE showed cryptic structure. ~33% of Albatross individuals assigned to species "A", along with all Contemporary individuals. Rest of Albatross individuals assigned to species "B". Looking at morphology, believe "A" is actually *Equulites laterofenestra* & "B" is *Leiognathus leuciscus*.

Adjusted popmap file to reflect new structure.

```bash
cd /home/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF
cp ../mkBAM/popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off ./popmap.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.HWEsplit

#added Ela- or Lle- to start of pop assignment (second column) to assign individual to either species.
```

Ran `fltrVCF.sbatch`.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF
cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.HWE

#troubleshooting will be necessary
```

---

### Step 12. Make VCF With monomorphic loci

**NOTE:** This, along with downstream filtering steps, can generate large amounts of data. If you are limited in your home storage space, you may want to run this in scratch.

Move the files needed for genotyping from `mkBAM` to `mkVCF`

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
mkdir mkVCF_monomorphic
mv mkBAM/*bam* mkVCF_monomorphic
mv mkBAM/*fq.gz mkVCF_monomorphic
cp mkBAM/*fasta mkVCF_monomorphic
cp mkBAM/config.5.cssl mkVCF_monomorphic/
```

Change the config file so that the last setting is (monomorphic) is set to yes and rename it with the suffix `.monomorphic`

```
yes     freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered 
```

Genotype

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic
sbatch ../../scripts/dDocentHPC_mkVCF.sbatch config.5.cssl.monomorphic
```

---

### Step 13. Filter VCF With monomorphic loci

Will filter for monomorphic & polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, probably best to do this in scratch.

Set-up filtering for monomorphic sites only.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic
cp ../scripts/config.fltr.ind.cssl.mono .
```

Ran `fltrVCF.sbatch` for monomorphic sites.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the TotalRawSNPs file made during the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file (step 9)
sbatch ../fltrVCF.sbatch config.fltr.ind.cssl.mono

#troubleshooting will be necessary
```

Set-up filtering for polymorphic sites only.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF/monomorphic
mkdir polymorphic_filter
cp ../../scripts/config.fltr.ind.cssl.poly .
```

Ran `fltrVCF.sbatch` for polymorphic sites.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the TotalRawSNPs file made during the "make monomorphic VCF" step
#popmap file should be file used in step 11, that accounts for any cryptic structure (*HWEsplit extension)
#settings should match the settings used when filtering the original VCF file (step 9)
sbatch ../../fltrVCF.sbatch config.fltr.ind.cssl.poly

#troubleshooting will be necessary
```

---

### Step 14. Merge monomorphic & polymorphic VCF files

Check monomorphic & polymorphic VCF files to make sure that filtering removed the same individuals. If not, remove necessary individuals from files.

* mono.VCF: filtering removed AHam_008, AHam_013, AHam_016, AHam_020, AHam_025, AHam_028, CNas_043 & CNas_063.
* poly.VCF: filtering removed AHam_008, AHam_013, AHam_016, AHam_020, AHam_025, CNas_043 & CNas_063. Need to remove AHam_028 as well to match monomorphic VCF.

Created `indv_missing.txt` in `mkVCF_monomorphic` directory. This is a list of all the individuals removed from either file (total of 8 for Lle). Used this list to make sure number of individuals matched in both filtered VCFs.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic
mv polymorphic_filter/lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.vcf .

module load vcftools

vcftools --vcf lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing
mv lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.recode.vcf lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.vcf

vcftools --vcf lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing
mv lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.recode.vcf lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.vcf
```

Sorted each VCF file.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load vcftools

#sort monomorphic
vcf-sort lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.vcf > lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.sorted.vcf

#sort polymorphic
vcf-sort lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.vcf > lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.sorted.vcf
```

Zipped each VCF file.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load samtools/1.9

#zip monomorphic
bgzip -c lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.sorted.vcf > lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.sorted.vcf.gz

#zip polymorphic
bgzip -c lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.sorted.vcf > lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Indexed each VCF file.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load samtools/1.9

#index monomorphic
tabix lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.sorted.vcf.gz

#index polymorphic
tabix lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Merged files.

```bash
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_leuciscus/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

crun bcftools concat --allow-overlaps lle.mono.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.11.recode.nomissing.sorted.vcf.gz lle.poly.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.20.recode.nomissing.sorted.vcf.gz -O z -o lle.all.recode.nomissing.sorted.vcf.gz

tabix lle.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses
```
