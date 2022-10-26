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

Copied raw (renamed) `*fq.gz` files to the longterm Carpenter RC directory.

```
cd /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing
mkdir leiognathus_equula

cd leiognathus_equula
mkdir fq_raw_cssl

cp /home/e1garica/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture/* fq_raw_cssl/
```

---

## Step 1.  Check data quality with fastqc

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula

#Multi_FastQC.sh "<file_extension>" "<indir>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture"

#once finished
mkdir /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula/Multi_FASTQC
mv /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/Multi_FASTQC/* /home/r3clark/PIRE/pire_cssl_data_processing/leiognathus_equula/Multi_FASTQC
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/leiognathus_equula/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQHSGSSFUNVKROXFDBGYYWGYTQB2MA).

Potential issues:  
* % duplication - fine
  * Alb: ~40%, Contemp: ~50%
* GC content - okay
  * Alb: 50%, Contemp: 45%
* number of reads - okay, not great
  * Alb: ~half <20 mil & ~half >20 mil, Contemp: ~10-20 mil

---

## Step 2. 1st fastp

Ran in `scratch` because don't have enough space in `home` directory.

```
cd /scratch/r3clark/leiognathus_equula

#runFASTP_1st_trim.sbatch <INDIR/full path to files> <OUTDIR/full path to desired outdir>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture fq_fp1
```

[Report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/leiognathus_equula/fq_fp1/1st_fastp_report.html?token=GHSAT0AAAAAABQHSGSTAW4WDXZ4BGRNGTR4YTQB2ZQ).

Potential issues:  
* % duplication - fine
  * Alb: ~30-40%, Contemp: ~40-50%
* GC content - okay
  * Alb: 50%, Contemp: 45%
* passing filter - good
  * Alb: >95%, Contemp: >98%
* % adapter - higher for Albatross, low for Contemp
  * Alb: 30-50%, Contemp: ~20%
* number of reads - okay, not great
  * Alb: ~half <20 mil & ~half >20 mil, Contemp: ~10-20 mil

Handing off to Brendan Reid for further processing - moved files to /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula for subsequent work.
 
---

## Step 3. Clumpify

I am copying the runCLUMPIFY bash and sbatch scripts to the Leq dir and modifying the sbatch script to avoid the bad node on Wahab.

Adding this line to the sbatch script:

```
#SBATCH --exclude=e1-w6420b-[01-24]
```

Ran clumpify with the following code:

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula
mkdir fq_fp1_clmp
bash runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/breid 10
```

Checking clumpify (copy checkClumpify_EG.R to fq_fp1_clmp dir first):

```
enable_lmod
module load container_env mapdamage2
crun R < checkClumpify_EG.R --no-save
```

Clumpify Successfully worked on all samples

## Step 4. Second trim

Again copying script and modifying to avoid the bad node on Wahab.

```
sbatch runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

Still more variation in read number for Albatross than contemporary samples. Otherwise looks surprisingly good - low duplication & % adapter, >99% passed filter across the board. I do see an adapter motif in the first 15 bp and a sawtooth pattern in GC content but I think we had decided to retain the first 15 bp, so not doing any additional trimming now.

## Step 5. Run fastq_screen

Again copying script and modifying to avoid the bad node on Wahab.

```
sbatch runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn
```
 
Checking output - should have 228 output files, looks like one failed: 

```
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l #227
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l #227 
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l #228
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l #227
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l #227
```

Checking logs for errors:

```
grep 'error' slurm-fqscrn.*out
slurm-fqscrn.691484.42.out:Can't write temp subset file: Input/output error at /opt/conda/bin/fastq_screen line 1630, <IN_SUBSET> line 58228412.
grep 'No reads in' slurm-fqscrn.*out
slurm-fqscrn.691484.42.out:No reads in Leq-ABas_021_Ex1_L3_clmp.fp2_r1.fq.gz, skipping
```

Checked the offending file but it looks fine? Trying to run again individually...

```
salloc

bash

export SINGULARITY_BIND=/home/e1garcia
module load container_env pire_genome_assembly/2021.07.01

FQSCRN=fastq_screen
CONFFILE=/home/e1garcia/shotgun_PIRE/fastq_screen/indexed_databases/runFQSCRN_6_nofish.conf
ALIGNER=bowtie2
FILTER=000000000000
SUBSET=0
OUTDIR=fq_fp1_clmp_fp2_fqscrn

crun $FQSCRN \
	--aligner $ALIGNER \
	--conf $CONFFILE \
	--threads 20 \
	--tag \
	--force \
	--filter $FILTER \
	--subset $SUBSET \
	--outdir $OUTDIR \
	fq_fp1_clmp_fp2/Leq-ABas_021_Ex1_L3_clmp.fp2_r1.fq.gz
```

All looks good now - 228 files!

## Step 6. Repair

Running from Leq directory:

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

And running MultiQC:

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/fq_fp1_clmp_fp2_fqscrn_repaired"
```

Check and perhaps rerun the QC steps - I don't think we got multiQC output after the fqscrn step. But we can draw some conclusions from the read loss calculations.

## Step 7. Reads lost

Running read loss calculator script (note the folder naming conventions for the raw data was different than in the original script, so I copied to here and changed before running):

```
sbatch read_calculator_ssl.sh "/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/leiognathus_equula"
```

Reads remaining lowest at clumify step - more variable for Albatross (~50-80%) than for contemporary (~55-60%).

Also a decent number of reads lost in fqscrn - again reads remaining lower/more variable in Albatross (40-85% of reads remaining) compared to contemporary (most >90%) suggesting more contamination in Albatross.

Still quite a lot of reads remaining for most libraries - almost all >1M.

## Step 8. Set up mapping dir, get reference genome

Make mapping dir and move `*fq.gz` files over.

```
mkdir mkBAM

mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAM
```

I got an error message when I tried to pull most recent changes to the scripts folder in Eric's pire_cssl. Cloning the dDocent repo to the species folder as a workaround. Then copied `config.5.cssl` over.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/dDocentHPC

git pull

#error: cannot update the ref 'refs/remotes/origin/main': unable to append to '.git/logs/refs/remotes/origin/main': Permission denied

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula

git clone https://github.com/cbirdlab/dDocentHPC.git

git pull

#works!

cp dDocentHPC/configs/config.5.cssl mkBAM

```

Because there is no whole genome reference for A. endrachtensis, I am using the full "raw" reference fasta from the RAD data used to make probes.

```
#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

cp /home/e1garcia/PIRE_ProbeTargets/05_Leiognathus_equula/PIRE_LeiognathusEquula.2.2.probes4development.fasta mkBAM/reference.rad.RAW-2-2.fasta
```

Update the config file with reference genome info

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/mkBAM

vi config.5.cssl
``` 

Inserted the appropriate reference genome values into the Cutoff 1 and 2 fields. Also changed the minimum mapping quality to 30 (value in the config file was originally 80) since that seems to be what was used in other cssl pipelines and 80 seems quite high! 

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
0.9             cdhit Clustering_Similarity_Pct (0-1)                                                   Use cdhit to cluster and collapse uniq reads by similarity threshold
rad               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
RAW-2-2               Cutoff2 (integer)
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

## Step 9. Map reads to reference - Filter Maps - Genotype Maps

Giving this a try

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/mkBAM

sbatch ../dDocentHPC/dDocentHPC.sbatch config.5.cssl
```

This didn't work with the sbatch script in the cloned dDocent repo! Checking the script in Rene's Tbi repo it looks quite different.

I think the repo cloned from cbird's github is not configured correctly for wahab? I don't know why we are directed to clone this repo.

I am now trying with the existing script in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts

```
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/dDocentHPC.sbatch config.5.cssl
```

This did not work either! Because it tries to direct to a dDocent folder in /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/ which does not exist.

So I think I see why we - we clone dDocent to the cssl /scripts directory and it finds the dDocent scripts there? But there is no dDocent folder in the that folder now and I'm not sure if I can pull. So going to try to customize a script that finds the right files in the folder I've cloned to Leq folder. Need to add singularity bind command too?

```
cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/dDocentHPC.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula


sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/dDocentHPC.sbatch config.5.cssl
```

Working!

## Step X. Preliminary filter (pre-HWE, before we check for structure/cryptic species) 

Clone Chris's fltrVCF and rad_haplotyper repos to species dir first 

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula 
git clone https://github.com/cbirdlab/fltrVCF.git
git clone https://github.com/cbirdlab/rad_haplotyper.git 

```

Move to fltrVCF dir, copy and modify config file (change name to indicate this is the first filter).

```
cd fltrVCF
cp config_files/config.fltr.ind.cssl ./
mv mv config.fltr.ind.cssl config.fltr.ind.cssl.1
```

See config file for changed settings - omitting the last 2 steps

Also modifying sbatch file to remove partition, email settings

Prior to running filter I'm going to check and see if any individuals have a huge amount of missing data

```
module load vcftools
cd mkBAM
vcftools --vcf TotalRawSNPs.rad.RAW-2-2.vcf --missing-indv
```

Contemporaries have generally <20% missing data, some up to 40%. Albatross are generally >40%, some as high as 90%. I don't see any clear cutoff though so I will filter everything.

Filtering with:

```
sbatch fltrVCF.sbatch config.fltr.ind.cssl.1
```

This did not work - I think this sbatch will work with the TAMUCC computer only?

Grabbed the sbathc from pire_cssl_data_processing/scripts, modified with singularity bind and correct file path for bash

Running (leq.A output prefix):

```
sbatch fltrVCF.sbatch config.fltr.ind.cssl.1
```

This worked - almost all of the Albatross individuals were filtered out due to missingness. Check allele balance as well!

I ran another filtering iteration with more permissive settings for missingness (0.75). Still lost multiple Albatross individuals but retained >20. These are the "leq.B" files. 

```
sbatch fltrVCF.sbatch config.fltr.ind.cssl.2
``` 

## Step 11. Initial popgen / checking for population structure / cryptic species.

Make a directory to work in:

``` 
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula
mkdir pop_structure
cd pop_structure
```

Copy final VCF file made from fltrVCF step to `pop_structure` directory.
```
cp ../fltrVCF/*Fltr07.18.vcf .
```

Run PCA and prepare files for Admixture in PLINK.

```
conda activate popgen
plink --vcf leq.B.rad.Fltr07.18.vcf --const-fid 0 --allow-extra-chr --pca --out PIRE.leq.B.preHWE
plink --vcf leq.B.rad.Fltr07.18.vcf --const-fid 0 --allow-extra-chr --make-bed --out PIRE.leq.B.preHWE
awk '{$1=0;print $0}' PIRE.leq.B.preHWE.bim > PIRE.leq.B.preHWE.bim.tmp
mv PIRE.leq.B.preHWE.bim.tmp PIRE.leq.B.preHWE.bim
```

Run Admixture for k={1-5].
```
bash
for K in 1 2 3 4 5; \
do admixture --cv PIRE.leq.B.preHWE.bed $K | tee log${K}.out; done
exit
conda deactivate
```

Copied *.eigenval, *.eigenvec & *.Q files to local computer. Ran pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R on local computer to visualize PCA & ADMIXTURE results (figures in pop_structure folder). K=1 has the lowest CV error, which supports a single population. No strong substructuring/clustering within eras. There are differences between Albatross and contemporary apparent in PCA + Admixture k=2 plot. This could just be capturing variation in levels of missing data though. There are some outlier individuals for both contemp and Albatross, look into these later (could be correlated with missing data as well). 

Running Roy + Chris + Eric's scripts to calculate mapping efficiency.

```
cp -r /home/cbird/roy/rroberts_thesis/scripts/bam_processing/ /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/bam_processing
sbatch getCVG.sbatch ../mkBAM out_cvg_Leq/
sbatch getSTATS.sbatch ../mkBAM out_stats_Leq/
sbatch mappedReadStats.sbatch ../mkBAM out_ReadStats_Leq/ Leq
cd out_ReadStats_Leq
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/popsummary_mappedReadStats.sh . out_Leq_ReadStats.tsv .
```

Outputs:
```
Printing aveReadStats_perPOP.tsv:
Population  n_samples  AVG_numreads  AVG_meanreadlength  AVG_meandepth_wcvg  AVG_numpos  AVG_numpos_wcvg  AVG_meandepth  AVG_pctpos_wcvg
Leq-ABas    52         141913        132.542             15.6178             2009762     666123           6.70227        33.1443
Leq-CMig    62         399886        143.909             31.2487             2009762     1.45564e+06      23.2095        72.4284

Printing samples_perMappedReads.tsv
Population  total_n_samples  n_mappedReads<100k  n_100-250k  n_250-500k  n_500k-1M  n_1-2M  n_>2M
Leq-ABas    52               29                  13          7           3          0       0
Leq-CMig    62               1                   10          34          17         0       0

Printing samples_perCVG.tsv:
Population  total_n_samples  n_meandepth_wcvg<10x  n_10x-20x  n_20x-30x  n_30x-40x  n_40x-50x  n_>50x
Leq-ABas    52               18                    16         17         1          0          0
Leq-CMig    62               0                     6          20         22         13         1
```

Fewer reads per sample and low-depth sites for Albatross. This jibes with a lot of Albatross (and some contemporary) individuals filtered out for missing data when running population structure. Suggest that we sequence the libraries to greater depth?
