# Lle Data Processing Log

copy and paste this into a new species dir and fill in as steps are accomplished.

---

## Step 1.  1st fastp

Locate data location in slack channel for this species to get the indir.  The outdir should be `/home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR`

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runFASTP_1.sbatch <indir> <outdir>
# do not use trailing / in paths
sbatch ../scripts/runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Lle/fq_raw fq_fp1
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/leiognathus_leuciscus/fq_fp1/1st_fastp_report.html?token=GHSAT0AAAAAABQHSGSS2QWVKS3C3KNKJH7IYTP746Q).

Potential issues:  
* % duplication - high for albatross, 
  * alb:70s, contemp: 50s
* gc content - reasonable
* passing filter - good
* % adapter - high, but that was expected, 
  * alb: 80s, contemp: 40s
* number of reads - decent
  * generally more for albatross than contemp, as we attempted to do
  * alb: 30mil, contemp: 8 mil
 
---

## Step 2. Clumpify

something odd happened here, so I'm running it again.

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
# do not use trailing / in paths
sbatch ../scripts/runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/cbird
#when complete, search the *out file for `java.lang.OutOfMemoryError`.  If this occurs, then increase ram, set groups to 1 in script
# no matches found
# I deleted the out file because it was causing a git problem, I added file to .gitignore to avoid future issues
```

this runs clumpify in an array, but the script is running out of memory

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runCLUMPIFY_r1r2_array.bash <indir> <outdir> <tempdir> <num nodes>
# do not use trailing / in paths
bash ../scripts/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmparray /scratch/cbird 20
```
---

## Step 3. Run fastp2

will need to run again with clumpify is done

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runFASTP_2.sbatch <indir> <outdir> 
# do not use trailing / in paths
sbatch ../scripts/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/leiognathus_leuciscus/fq_fp1_clmp_fp2/2nd_fastp_report_2.html?token=GHSAT0AAAAAABQHSGSSILAWYECPG7PRFGPWYTP75XQ).

Potential issues:  
* % duplication - good  
  * alb:20s, contemp: 20s
* gc content - reasonable
  * alb: 40s, contemp: 40s 
* passing filter - good
  * alb: 90s, contemp: 90s 
* % adapter - good
  * alb: 2s, contemp: 2s
* number of reads - lost alot for albatross
  * generally more for albatross than contemp, as we attempted to do
  * alb: 7 mil, contemp: YY mil

---

## Step 4. Run fastq_screen

I edited runFQSCRN_6* to run on wahab.

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously>
# do not use trailing / in paths
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20

# check output for errors
grep 'error' slurm-fqscrn.266713*out | less -S
grep 'No reads in' slurm-fqscrn.266713*out | less -S
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/leiognathus_leuciscus/fq_fp1_clmp_fp2_fqscrn/fqscrn_report_1.html?token=GHSAT0AAAAAABQHSGSTYHZVDOGNTPC6FN4QYTP76LQ).

Potential issues:
* job 9 failed
  * [out file](./logs/LlA01005_CKDL210012719-1a-AK6260-7UDI308_HF5TCDSX2_L1_clmp_fp2_r2.fq.gz)
  * "No reads in LlA01005_CKDL210012719-1a-AK6260-7UDI308_HF5TCDSX2_L1_clmp_fp2_r2.fq.gz, skipping" 
  * I checked this file, there are plenty of reads


Fix errors: all I had to do was run the files again that returned the "No reads in" error and they worked fine

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously> <fq file pattern to process>
# do not use trailing / in paths
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 LlA01010*r1.fq.gz
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 LlA01005*r2.fq.gz
```

Cleanup logs

```bash
mkdir logs
mv *out logs
```

---

## Step 5. Repair fastq_screen paired end files

This went smoothly.

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
# runREPAIR.sbatch <indir> <outdir> <threads>
sbatch ../scripts/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

---

## Step 6. Rename files for dDocentHPC and put into mapping dir

files names must be formatted as follows:
  * `population_individual.R1.fq.gz`
    * only 1 `_`
    * must end in `.R1.fq.gz` or `.R2.fq.gz`

The goal here is to convert the names from the seq facility, which are limited, to our sample name format.

It is desireable to keep seq name info that could be useful later on, like lane, R1, R2, processing, etc

I am taking advantage of the fact that when the seq names are sorted, their samp names are also sorted (I'm using order rather than the match between col 1 and 2 in the decode file).  Don't forget to remove the carriage returns `\r`.

I made a script to do all this, then we can replace old file names with new file names

If you don't have the decode file, it shoudl be in with the raw fqgz files.  If not it can be obtained from Sharon Magnuson or Chris Bird

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#mkNewFileNames.bash <decode file name> <fqdir>, does not include path
bash ../scripts/mkNewFileNames.bash Lle_CaptureLibraries_SequenceNameDecode.tsv fq_fp1_clmp_fp2_fqscrn_repaired > decode_newnames.txt

#make old file names, will include path
ls fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz > decode_oldnames.txt

# triple check that the old and new files are aligned
module load parallel
bash #need for odu
parallel --no-notice --link -kj6 "echo {1}, {2}" :::: decode_oldnames.txt decode_newnames.txt > decode_translation.csv
less -S decode_translation.csv

# rename files and move to mapping dir
mkdir mkBAM
parallel --no-notice --link -kj6 "mv {1} mkBAM/{2}" :::: decode_oldnames.txt decode_newnames.txt

# confirm success
ls mkBAM
```

---

## Step 7.  Set up mapping dir and get reference genome

Clone dDocentHPC repo (this is on the .gitignore list, so nothing inside it will be added to the present repo)

```bash
cd /home/cbird/pire_cssl_data_processing/scripts
git clone git@github.com:cbirdlab/dDocentHPC.git
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
cp ../scripts/dDocentHPC/configs/config.5.cssl mkBAM
```

The best genome can be found by running [`wrangleData.R`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/compare_assemblers), sorting tibble by busco single copy complete, quast n50, and filtering by species in Rstudio.

Then copy best ref genome to your dir.  The correct dir can be inferred from the busco tibbles.  For reference, the best assembly for Lle is as follows:

```bash
# the destination reference fasta should be named as follows reference.<assembly type>.<unique assembly info>.fasta
# <assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovoe assembled rad library
# this naming is a little messy, but it makes the ref 100% tracable back to the source
# it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes
cp /home/cbird/pire_shotgun/lle_spades/out_Lle-C_3NR_R1R2ORPH_contam_noisolate_covcutoff-off/scaffolds.fasta mkBAM/reference.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.fasta
```

Update the config file with the ref genome info

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM
nano config.5.cssl
```

Insert `<assembly type>` into `Cutoff1` variable and `<unique assembly info>` into `Cutoff2` variable
 
```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=$0.9             cdhit Clustering_Similarity_Pct (0-1)                                                   Use cdhit to cluster and collapse uniq reads by similarity threshold
ssl               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
Lle-C_3NR_R1R2ORPH_contam_noisolate_covcutoff-off               Cutoff2 (integer)
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

## Step 8. Map reads to reference - Filter Maps - Genotype Maps

Clone dDocentHPC repo

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus/mkBAM
#this has to be run from dir with fq.gz files to be mapped and the ref genome
# this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../../scripts/dDocentHPC.sbatch config.5.cssl

# troubleshooting may be necessary, don't rerun steps that worked previously (i.e. copy and paste sbatch to local dir and modify for troubleshooting).
```

---

## Step 9. Filter VCF files

Clone fltrVCF and rad_haplotyper repos

```bash
cd /home/cbird/pire_cssl_data_processing/scripts
git clone git@github.com:cbirdlab/fltrVCF.git
git clone git@github.com:cbirdlab/rad_haplotyper.git

cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus/
mkdir filterVCF

cp ../scripts/fltrVCF/config_files/config.fltr.ind.cssl filterVCF
```

Ran `fltrVCF.sbatch`.

```bash
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus/filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to the second 07 filter (remove filters 18 & 17 from list of filters to run)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl

# troubleshooting will be necessary).
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
