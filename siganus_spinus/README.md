## Siganus spinus CSSL data processing

### 1. Rename files

Trying the re-vamped (as of 9/29/22) rename script. So far, seems to be working as intended!

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZc.bash Ssp_CaptureLibraries_SequenceNameDecode.tsv
```

Other directory setup:
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/
mkdir logs
```

Copying raw (renamed) seqs to RC since they are not there yet!

```
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus
cp -r raw_fq_capture /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus
```

### 2. fq.gz processing

Attempting to run MultiQC.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "fq.gz"
```

MultiQC is stalling at one specific file for some reason. Trying to run it now on A files first, then C files

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-A*fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-C*fq.gz"
```

Still stalls - does not work for: 
Ssp-AAtu_021, Ssp-AAtu_043, Ssp-AAtu_046
Ssp-CGub_004, Ssp-CGub_011, Ssp-CGub_040, Ssp-CGub_049, Ssp-CGub_056, Ssp-CGub_059, Ssp-CGub_091

For some reason these are all of the files with sizes in the range 7-25 Mb. All files smaller or larger worked. No indication that anything is particularly weird - .1 and .2 files are same # of lines (so probably nothing went wrong in file transfer) and look like regular fq.gz files.

Re-trying Albatross failures with modified SingleQC script. These are stalling too.
```
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.1.fq.gz"
```

Re-trying failures with SingleQC script - no parallel. It works!!
```
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_004-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_004-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_011-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_011-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_040-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_040-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_049-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_049-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_056-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_056-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_059-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_059-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_091-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_091-Ex1-cssl.2.fq.gz"
```

Run MultiQC.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" fastqc_report
```

MultiQC [report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/raw_fq_capture/fastqc_report.html) summary:
* Highly variable # of sequences. 100k - 104.8M. Most Albatross between 500k-1M.
* Quality looks OK.
* GC content warnings for some Albatross samples - bimodal distribution of GC content (target + contamination? Maybe this will be fixed in fqscreen) 
* Low N content, good sequence lengths
* High duplication for Albatross + some contemps (to be expected for capture?)
* High adapter content, some overrepresented sequence warnings.

### 3. First trim.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/

#sbatch runFASTP_1st_trim.sbatch <indir> <outdir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch raw_fq_capture fq_fp1
```

MultiQC [report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/fq_fp1/1st_fastp_report.html) summary:
* Most reads for Albatross + contemporary pass filter
* High duplication + % adapter still for a lot of Albatross.
* GC content variable for Albatross
* Lower insert size on average for Albatross

### 4. Clumpify / remove duplicates

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/

#runCLUMPIFY_r1r2_array.bash <indir; fast1 files> <outdir> <tempdir> <max # of nodes to use at once>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/breid 20
```

Check clumpify.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2

cp /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R .

crun R < checkClumpify_EG.R --no-save
exit #to relinquish the interactive node
```

Clumpify Successfully worked on all samples!

### 5. Second fastp trim.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

MultiQC [report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/fq_fp1_clmp_fp2/2nd_fastp_report.html). Duplication and % adapter way down for Albatross samples (now ~20% + 1% respectively). Still some high GC samples.

### 6. Decontaminate

```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```

Checking that all went well.

```
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l

# all 196!!

grep 'error' logs/slurm-fqscrn.*out
grep 'No reads in' logs/slurm-fqscrn.*out

# nothing!
```

Run MultiQC.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastqc_screen_report
```

MultiQC [summary](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/fq_fp1_clmp_fp2_fqscrn/fastqc_screen_report.html).
* Most sequences "no-hit"
* Bacteria or multiple genomes are significant secondary components, more common in Albatross samps (and a few contemp samples)
* Three Albatross specimens have substantial amounts of human DNA.

### 7. Run re-pair

```
#runREPAIR.sbatch <indir; fqscreen files> <outdir> <threads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

Run Multi_FASTQC!

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/fq_fp1_clmp_fp2_fqscrn_repaired" "fq.gz"
```

MultiQC [summary](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/fq_fp1_clmp_fp2_fqscrn_repaired/fastqc_report.html).

* GC content still an issue after fqscreen (although peak at 50% for some is gone).
* Per tile quality is an issue now - should that be a concern? 

### 8. Calculate % reads lost

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/read_calculator_cssl.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus"
```

Tables for [readLoss](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/preprocess_read_change/readLoss_table.tsv) and [readsRemaining](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/preprocess_read_change/readsRemaining_table.tsv).

* Lots of reads lost at clumpify step (de-duplication, makes sense).
* More reads lost for Albatross at decontamination.
* Still >100k reads for most Albatross, although there still may be contamination based on GC content.

Moving on to CSSL pipeline!

## Mapping and Filtering Data

### Setting up mapping directory and reference genome

Make mapping directory and move files to map.
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus
mkdir mkBAM
mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAM
```

Clone dDocent, copy config file.
```
git clone https://github.com/cbirdlab/dDocentHPC.git
cd mkBAM
cp ../dDocentHPC/configs/config.5.cssl .
```

Careful with the reference genome! Ssp libraries were mislabelled as Sob in the original denovo genome assembly project.
Should use a _decontam_ assembly since I am worried about bacterial contamination in the Albatross cssl data.
Assembly labeled "Sob_10NR_decontam" looks lke it is best (highest BUSCO + N50).

```
#un-tar the assembly
cp ../../../sob_spades/out_Sob-C_10NR_R1R2ORPH_decontam_noisolate_covcutoff-off.tar.gz ../
cd ..
tar -xvzf out_Sob-C_10NR_R1R2ORPH_decontam_noisolate_covcutoff-off.tar.gz
#output ended up in a dir called "home/cbird/pire_shotgun/sob_spades/out_Sob-C_10NR_R1R2ORPH_decontam_noisolate_covcutoff-off" in siganus_spinus folder
cp home/cbird/pire_shotgun/sob_spades/out_Sob-C_10NR_R1R2ORPH_decontam_noisolate_covcutoff-off/scaffolds.fasta mkBAM/
#rename reference
mv scaffolds.fasta reference.ssl.Ssp-10NR-R1R2ORPH-decontam-noisolate.fasta
#removing assembly dir
cd ..
rm -r home/cbird/pire_shotgun/sob_spades/out_Sob-C_10NR_R1R2ORPH_decontam_noisolate_covcutoff-off
cd mkBAM
```

Update config5.cssl.

```
ssl               Cutoff1 (integer) 
Ssp-10NR-R1R2ORPH-decontam-noisolate               Cutoff2 (integer)
```

## Run dDocent - map reads to reference, filter, call variable sites

Try running dDocent wth the modified scripts as done for Leq.

```
cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/dDocentHPC.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/mkBAM/
# add export SINGULARITY_BIND=/home/e1garcia + correct pathways
sbatch dDocentHPC.sbatch config.5.cssl
```

dDocent ran mkBAM and fltrBAM successfully but there was an error with mkVCF: `[E::hts_idx_push] Chromosome blocks not continuous`

I am going to try again using the original reference used for probe development (3NR_contam) to see if that fixes the error.

```
mkdir /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/mkBAM_probedevref/
cp ../../../sob_spades/out_Sob-C_3NR_R1R2ORPH_contam_noisolate_covcutoff-off.tar.gz ../
tar -xzvf out_Sob-C_3NR_R1R2ORPH_contam_noisolate_covcutoff-off.tar.gz
cp home/cbird/pire_shotgun/sob_spades/out_Sob-C_3NR_R1R2ORPH_contam_noisolate_covcutoff-off/scaffolds.fasta /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/mkBAM_probedevref/
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/mkBAM_probedevref/
mv scaffolds.fasta reference.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.fasta
cp ../mkBAM/config.5.cssl ./
vi config.5.cssl
## change ref name
cp ../mkBAM/dDocentHPC.sbatch ./
sbatch dDocentHPC.sbatch config.5.cssl
```

Received the same error message mapping to reference.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.fasta !

I resolved this error by sorting again using vcf-sort and running tabix.

```
salloc
module load vcftools
module load htslib
vcf-sort TotalRawSNPs.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.vcf > TotalRawSNPs.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate-resort.vcf
bgzip TotalRawSNPs.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate-resort.vcf
tabix TotalRawSNPs.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate-resort.vcf.gz
```

Running Roy + Chris's scripts to calculate mapping efficiency.

```
cp -r /home/cbird/roy/rroberts_thesis/scripts/bam_processing/ /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/bam_processing
sbatch getCVG.sbatch ../mkBAM out_cvg_Ssp10NRdecontam/
sbatch getCVG.sbatch ../mkBAM_probedevref out_cvg_Ssp3NRcontam/
sbatch getSTATS.sbatch ../mkBAM out_stats_Ssp10NRdecontam/
sbatch getSTATS.sbatch ../mkBAM_probedevref out_stats_Ssp3NRcontam/
sbatch mappedReadStats.sbatch ../mkBAM out_ReadStats_Ssp10NRdecontam/ Ssp
sbatch mappedReadStats.sbatch ../mkBAM_probedevref out_ReadStats_Ssp3NRcontam/ Ssp
```

## Preliminary filter (pre-HWE, before we check for structure/cryptic species) 

Clone Chris's fltrVCF and rad_haplotyper repos to species dir first 

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus 
git clone https://github.com/cbirdlab/fltrVCF.git
git clone https://github.com/cbirdlab/rad_haplotyper.git 

```

Move to fltrVCF dir, copy and modify config file (change name to indicate this is the first filter).

```
cd fltrVCF
cp config_files/config.fltr.ind.cssl ./
mv config.fltr.ind.cssl config.fltr.ind.cssl.1
```

See config file for changed settings - omitting the last 2 steps

Grabbing the sbatch from `pire_cssl_data_processing/leiognathus_equula/fltrVCF` and running

```
cp ../../leiognathus_equula/fltrVCF/fltrVCF.sbatch .
sbatch fltrVCF.sbatch config.fltr.ind.cssl.1
```

Lost a decent number of Albatross individuals in filtering (15 Albatross individuals left vs 45 contemporary) and 1714 sites. Lots of sites lost in "remove sites called in <X proportion of individuals" step.

Still a decent number of Albatross individuals so trying an initial popgen analysis.

## Initial popgen

Make a directory to work in:

``` 
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus
mkdir pop_structure
cd pop_structure
```

Copy final VCF file made from fltrVCF step to `pop_structure` directory.

```
cp ../fltrVCF/*Fltr07.18.vcf .
```

Run PCA and prepare files for Admixture in PLINK.

```
module load anaconda
conda activate popgen
#problem with vcf ordering appeared again... re-sorting!
module load vcftools
module load htslib
vcf-sort ssp.A.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.Fltr07.18.vcf > ssp.A.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.Fltr07.18-resort.vcf
plink --vcf ssp.A.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.Fltr07.18-resort.vcf --const-fid 0 --allow-extra-chr --pca --out PIRE.ssp.A.preHWE
plink --vcf ssp.A.ssl.Ssp-3NR-R1R2ORPH-contam-noisolate.Fltr07.18-resort.vcf --const-fid 0 --allow-extra-chr --make-bed --out PIRE.ssp.A.preHWE
awk '{$1=0;print $0}' PIRE.ssp.A.preHWE.bim > PIRE.ssp.A.preHWE.bim.tmp
mv PIRE.ssp.A.preHWE.bim.tmp PIRE.ssp.A.preHWE.bim
```

Run Admixture for k={1-5].
```
bash
for K in 1 2 3 4 5; \
do admixture --cv PIRE.ssp.A.preHWE.bed $K | tee log${K}.out; done
exit
conda deactivate
```

Copy *.eigenval, *.eigenvec & *.Q files to local computer and run pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R on local computer to visualize PCA & ADMIXTURE results (figures in pop_structure folder).

Results all strongly suggest contemporary and historic are different species!

## Running MitoZ to get COI

New scripts (runMitoZ_array.bash, runMitoZ_array.sbatch, and process_MitoZ_outputs.sh).

```
runMitoZ_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/fq_fp1_clmp_fp2 32
sh process_MitoZ_outputs.sh
```

Worked for ~2/3 of contemporary libraries (all IDed as Siganus spinus in BOLD) but no Albatross libraries!
