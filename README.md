# CAPTURE SHOTGUN DATA PROCESSING & ANALYSIS

---

The purpose of this repo is to document the processing and analysis of `Capture Sequencing Libraries - CSSL data` for the Philippines PIRE Project. These data were generated using probes that resulted from the [Shotgun Sequencing Libraries - SSL repo](https://github.com/philippinespire/pire_ssl_data_processing). Both CSSL and SSL pipelines use scripts from the [Pre-Processing PIRE Data](https://github.com/philippinespire/pire_fq_gz_processing) repo at the beginning of files processing.  

For now, each species will get its own directory in the repo.  Try to avoing putting dirs inside dirs inside dirs.  

## Details
	
**The Gmi dir (all steps) & Tzo dir (through genotyping) will serve as the examples to follow in terms of both directory structure and documentation of progress in `README.md`. The `README.md` structure for your species should follow this format as closely as possible.**

  * A template version of can be found [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/README.md).

Contact Dr. Eric Garcia for questions or if you are having issues running scripts (e1garcia@odu.edu).

---

<details><summary>Use Git/GitHub to Track Progress</summary>
<p>
	
## Use Git/GitHub to Track Progress

To process a species, begin by cloning this repo to your working dir. We recommend setting up a shotgun_PIRE sub-dir in your home dir if you have not done something similar already.

Example: `/home/youruserID/shotgun_PIRE/`

Clone this repo

```
cd ~ #this will take you to your home dir
cd shotgun_PIRE
git clone https://github.com/philippinespire/pire_ssl_data_processing.git

#you can also work out of Eric's shotgun_PIRE directory if you want to save space. (/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing)
```

The data will be processed and analyzed in the repo.  There is a `.gitignore` file that lists files and directories to be ignored by git.  It includes large files that git cannot handle (fq.gz, bam, etc) and other repos that might be downloaded into this repo. For example, the dir `dDocentHPC` contains the [dDocentHPC](https://github.com/cbirdlab/dDocentHPC) repo you will be using, but we don't need to save that to this repo, so `dDocentHPC/` occurs in  `.gitignore` so that it is not uploaded to GitHub in this repo.

Because large data files will not be saved to GitHub, they will reside in an individual's copy of the repo (or somewhere else on the HPC). You should provide paths (absolute/full paths are probably best) or info that make it clear where the files reside. Most of these large intermediate files should be deleted once it is confirmed that they worked. (Ex: We don't ultimately need the intermediate fq.gz files produced by fastp, clumpify, fastq_screen, etc.)

A list of ongoing CSSL projects can be found below. If you are working on a CSSL analysis project (or if you wish to claim a project), please indicate so in the table.

|Species | Data availability | Analysis lead | Analysis status / notes |
| --- | --- | --- | --- |
|Aen | On ODU HPC | Rene | Pop gen (ongoing) |
|Gmi | On ODU HPC | Rene | Pop gen (ongoing) |
|Lle | On ODU HPC | Rene | Pop gen (ongoing) |
|Sde | On ODU HPC | Eric | QC complete? |
|Leq | On ODU HPC | John + Brendan | QC started (fastp1 done as of 5/2) |
|Tbi | On ODU HPC | | unfiltered VCF created (as of 5/27) |
|Tzo | On ODU HPC | Kyra | unfiltered VCF created (as of 5/10) |
|Hte | On ODU HPC | Brendan | Data generated with incorrect probes, some pops missing |
|Hmi | On ODU HPC | Ivan | QC needs to be done |
|Sde | On ODU HPC | Eric / Omar | Second batch of data - QC needs to be done, combine with first batch for postQC/SNP calling steps |
|Sgr | On ODU HPC | Eric | QC needs to be done |
|Sfa | On ODU HPC | Jem | fltrBAM done as of 05/11/2023, proceeding with GenErode, Atlas then ANGSD |
|Ssp | On ODU HPC | Brendan | QC needs to be done |

</p>
</details>

---

<details><summary>Maintaining Git Repo</summary>
<p>
	
## Maintaining Git Repo

You must pull down the lated version of the repo everytime you sit down to work and push the changes you made everytime you walk away from the terminal.  The following order of operations when you sync the repo will minimize problems.

From your species directory, execute these commands manually or run the `runGit.bash` script (see below).

```sh
git pull
git add --all
git commit -m "insert message"
git push
```

This code has been compiled into the script [`runGIT.bash`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/runGIT.bash) thus you can just run this script BEFORE and AFTER you do anything in your species repo. You will need to provide the message of your commit in the command line. Example:

```bash
bash ../runGIT.bash "initiated Sgr repo"
```

You will need to enter your git credentials multiple times each time you run this script (or push any changes manually).

If you should be met with a conflict screen, you are in the archane `vim` editor.  You can look up instructions on how to interface with it. We suggest the following:

* hit escape key twice
* type the following:
  `:quit!`
  
If you have to delete files for whatever reason, these deletions occurred in your local directory. However, these files will remain in the git memory if they had already entered the system (been pushed).

If you are in this situation, run these git commands manually, AFTER running the `runGIT.bash` as described above (or pulling manually). The command `add -u` will stage your deleted files, then you can commit and push.

Run this from the directory where you deleted files:

```sh
git add -u .
git commit -m "update deletions"
git push -u origin main
```

</p>
</details>

---

<details><summary>Pre-Processing Sequences</summary>
<p>

## A. PRE-PROCESSING SEQUENCES

Go to the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) repo and complete the steps then return here.

  * This includes running FASTQC, FASTP1, CLUMPIFY, FASTP2, FASTQ_SCREEN, and file re-pair scripts.
  * Make sure you are running the **CSSL** versions of any scripts when necessary.
  
</p>
</details>

---

<details><summary>Mapping & Filtering Data</summary>
<p>
	
## B. MAPPING & FILTERING DATA

## 1. Set up mapping directory

Make a mapping directory and make "hard links" to the re-paired `*fq.gz` files inside `mkBAM`.  This ensures that files stay where they belong (e.g., where they were originally created), but will create links to the original files in the `mkBAM` dir.  

 * You can double check that these are hard links by typing the command `ls -l` and looking for:
    1. A "2" rather than a "1" in the 2nd column
    2. A "-" (file) rather than a "d" (dir) in the very first character of the row

```bash
cd YOUR_SPECIES_DIR

mkdir mkBAM
ln fq_fp1_clmp_fp2_fqscrn_rprd/*fq.gz mkBAM
```

If you are **NOT** working with `e1garcia`, clone the [`dDocentHPC`](https://github.com/cbirdlab/dDocentHPC) repo.

  * If you have previously cloned `dDocentHPC` just pull any of the latest changes with `git pull`.
  * DO NOT do this step if you were working within `e1garcia` (`shotgun_PIRE/dDocentHPC` dir is already cloned).

```bash
cd YOUR_SPECIES_DIR
cd ../../

# you should now be in the dir that holds your CSSL repo dir
# DO NOT do this if you are in e1garcia dir on wahab
git clone https://github.com/cbirdlab/dDocentHPC.git
```

Copy the dDocentHPC config file and sbatch file to your mkBAM dir

```bash
cd YOUR_SPECIES_DIR/mkBAM
cp /../../../dDocentHPC/configs/config.6.cssl .
cp /../../../dDocentHPC/dDocentHPC.sbatch .
```

---

## 2. Get reference genome

#### **IF YOUR SPECIES HAS AN ASSEMBLED GENOME *(most species)*:** 
Find the best genome in the `/home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/<genus_species>/probe_design/` dir.  It should be a `*.fasta` file.  This genome was selected during the ssl processing by running [`wrangleData.R`](https://github.com/philippinespire/denovo_genome_assembly/blob/main/compare_assemblers/wrangle_data.R) and sorting the tibble by (1) BUSCO single copy complete and (2) QUAST n50, then filtering by species. *You can also look at the README of your species in the SSL directory (pire_ssl_data_processing) - the best genome should be listed there as well.* 

#### **IF YOUR SPECIES DOES NOT HAVE AN ASSEMBLED GENOME *(species where probes came from RAD data)*:** 
Find the "raw" reference fasta that was used for probe development (it will be the `*probes4development.fasta` that has NOT been filtered) and use that as your "best assembly" for mapping. You may have to dig through the Slack channel for your species and contact the individual responsible for creating this file to identify its location. *Most should be available in the relevant species folder on Wahab (`/RC/group/rc_carpenterlab_ngs/rad_PIRE`).*

  * This should only apply to the following species: *Atherinomorus endrachtensis*, *Gazza minuta*, *Leiognathus equula*, and *Spratelloides delicatulus*.
    * *Ambassis urotaenia*, *Leiognathus leuciscus*, and *Siganus spinus* also had probes made from RAD data but have a whole genome assembly to map to.

Copy the best genome to `mkBAM`. Rename in the process.

Example for Tzo:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/mkBAM

cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/taeniamia_zosterophora/probe_design/Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta .

#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta ./reference.ssl.Tzo-C-0402G-R1R2-contam-noisolate.fasta
```

Update `config.6.cssl` with the reference genome assembly information. You only need to udpdate the `mkREF` section.

Insert `<assembly type>` into the `Cutoff1` variable and `<unique assembly info>` into the `Cutoff2` variable. *Hint: this will match how you renamed the reference assembly fasta.*

Example for Tzo:

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
ssl               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
Tzo-C-0402G-R1R2-contam-noisolate               Cutoff2 (integer)
                Use unique reads that occur in at least this many individuals for making the reference genome
0.05    rainbow merge -r <percentile> (decimal 0-1)                                             Percentile-based minimum number of seqs to assemble in a precluster
0.95    rainbow merge -R <percentile> (decimal 0-1)                                             Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------
```

---

## 3. Adjust mkBAM Settings in `config.6.cssl`

Adjust the mkBAM settings as desired:

```
----------mkBAM: Settings for mapping the reads to the reference genome-------------------------------------------
Make sure the cutoffs above match the reference*fasta!
1		bwa mem -A Mapping_Match_Value (integer) 						bwa mem default is 1
4		bwa mem -B Mapping_MisMatch_Value (integer) 					bwa mem default is 4
6		bwa mem -O Mapping_GapOpen_Penalty (integer) 					bwa mem default is 6
30		bwa mem -T Mapping_Minimum_Alignment_Score (integer) 			bwa mem default is 30. Remove reads that have an alignment score less than this. don't go lower than 1 or else the resulting file will be huge. NOTE! in fltrBAM settings (below) there is an alignment score filter that uses a threshold relative to read length.  This -T setting here affects which reads the relative alignment score threshold will be applied to.
5	bwa mem -L Mapping_Clipping_Penalty (integer,integer) 			bwa mem default is 5
------------------------------------------------------------------------------------------------------------------
```

These settings work as follows:

**1	bwa mem -A Mapping_Match_Value (integer) 	bwa mem default is 1**

 * For every matching base between the ref genome and a read, this value is added to the alignment score.
   * If all the bases match, then the maximum alignment score = bp * (A).

**4	bwa mem -B Mapping_MisMatch_Value (integer) 	bwa mem default is 4**

 * For every mismatch between the ref genome and a read, this value is subtracted from the alignment score.
   * If there is 1 mismatch, then the alignment score = bp * A - (A + B).

**6	bwa mem -O Mapping_GapOpen_Penalty (integer) 	bwa mem default is 6**

 * This filter works similarly to the mismatches one, but for gap opens. We have never encountered a situation where we wanted to adjust the gap extend penalty, so it is not accessible from the config file.

**13	bwa mem -T Mapping_Minimum_Alignment_Score (integer) 	bwa mem default is 30. Remove reads that have an alignment score less than this. don't go lower than 1 or else the resulting file will be huge. NOTE! in fltrBAM settings (below) there is an alignment score filter that uses a threshold relative to read length.  This -T setting here affects which reads the relative alignment score threshold will be applied to.**

 * This is the threshold alignment score above which all reads are kept and below which reads are classified as unmapped.
 * This setting has a lot of power. If all of your reads are the same length, then you don't have much to worry about.  Set this at the value you want.
    * **Example 1:** All my reads are 150 bp (because with fastp, I removed any read shorter than this length). I want to go with the bwa mem default value of 30 because I trust that this is the correct value.  150-30=120.  120/(A+B) = 24 mismatches (e.g. 16% of all bases are allowed to be mismatched).  120/(A+O) = 17 gap opens allowed. Any reads with an alignment score lower than this will be removed.
    * **Example 2:** All my reads are 150 bp, but I do not trust the default settings.  I decide that I'm more comfortable with a threshold of 10% of bases mismatching, so I change T to be 150 - 15 * (A+B) = 75.
 * If your reads have a broad distribution of lengths, as might be expected from degraded samples (aDNA, historical DNA, etc), then you have to take a different approach because the alignment score is heavily affected by read length and you don't want to bias the heterozygosity of your data by read length. In this case, we suggest adjusting this setting based on your shortest read length (later on in the pipeline, fltrBAM will apply a "read length aware" filter to take care of the longer reads). You don't just want to set T to zero (bad idea), as you'll generate massive bam files, so you do want some filtering to happen at this step.
    * **Example 3:** My shortest reads are 50 bp because in fastp I removed any read shorter than 50 bp. I assume that the authors of bwa mem set the defaults assuming that the read lengths are 150 (the Illumina std length), and I want to adjust that default to apply to reads that are 50 bp by allowing up to 16% mismatching bases.  So, I change T to be 50 - (A+B) * 50 * 0.16 = 10.
    * **Example 4:** My shortest reads are 33 bp because in fastp I removed any read shorter than 33 bp. I know something about the biology and genome architecture of my species and would prefer to keep reads with 10% or fewer mismatches.  So, I change T to be 33 - (A+B) * 33 * 0.10 = 16.5 ~ 16.
 * **NOTE:** In all the above examples, we were making our decisions based on the (potential) number of mismatched bases we were comfortable with. You can obviously also make the same calculations based on gaps as well. 

### 5	bwa mem -L Mapping_Clipping_Penalty (integer,integer) 			bwa mem default is 5

Read the BWA manual.



---

## Map reads to reference

Run [`dDocentHPC.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC.sbatch) to map, filter the resulting bam files, and call variable sites.

```sh
cd YOUR_SPECIES_DIR/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch dDocentHPC.sbatch mkBAM config.6.cssl
```

---

# Filtering the bam files

## ADJUSTING fltrBAM SETTINGS in `config.6.cssl`

_*It is always a good idea to spot check your alignments using IGV, both before and after filtering to confirm the effects of the filters and to identify abnormalities that you want to remove*_


```
----------fltrBAM: Settings for filtering mapping alignments in the *bam files---------------
30		samtools view -q 		Mapping_Min_Quality (integer)    									Remove reads with mapping qual less than this value
yes		samtools view -F 4 		Remove_unmapped_reads? (yes,no)   									Since the reads aren't mapped, we generally don't need to filter them
no		samtools view -F 8 		Remove_read_pair_if_one_is_unmapped? (yes,no)    					If either read in a pair does not map, then the other is also removed
yes		samtools view -F 256 	Remove_secondary_alignments? (yes,no)     							Secondary alignments are reads that also map to other contigs in the reference genome
no		samtools view -F 512 	Remove_reads_not_passing_platform_vendor_filters (yes,no)     		We generally don't see any of these
no		samtools view -F 1024 	Remove_PCR_or_optical_duplicates? (yes,no)     						You probably don't want to set this to yes
yes		samtools view -F 2048 	Remove_supplementary_alignments? (yes,no)     						We generally don't see any of these
no		samtools view -f 2 		Keep_only_properly_aligned_read_pairs? (yes,no)						Set to no if OL mode 
0		samtools view -F 		Custom_samtools_view_F_bit_value? (integer)     					performed separately from the above, consult samtools man
0		samtools view -f 		Custom_samtools_view_f_bit_value? (integer)     					performed separately from the above, consult samtools man
no		Remove_reads_with_excessive_soft_clipping? (no, integers)			minimum number of soft clipped bases in a read, summed between the beginning and end, that are unacceptable
50		Remove_reads_with_alignment_score_below_relative_threshold (integer)	Alignment score thresholds are calculated based on this value adjusted by a factor (actual read length relative the assumed read length value in next setting). RelativeThreshold = as_threshold * actual_read_length / assumed_read_length, where this setting controls as_threshold. NOTE! bwa mem -T affects which reads are mapped based on alignment score, and therefore this filter cannot save reads elimated by bwa mem -T, but if the -T setting is too low then the RAW bam files can be huge.
100		Read_length_assumed_by_relative_alignment_score_threshold (integer)	Alignment score thresholds are calculated based on the threshold in the previous setting adjusted by a factor (actual read length relative the assumed read length value here). RelativeThreshold= as_threshold * actual_read_length / assumed_read_length, where this setting controls assumed_read_length
no		Remove_reads_orphaned_by_filters? (yes,no)
------------------------------------------------------------------------------------------------------------------

```

Most of the fltrBAM settings are self explanitory. But some are non-intuitive. 

### no		samtools view -F 1024 	Remove_PCR_or_optical_duplicates? (yes,no) 

I haven't seen this filter to have an effect on the data and remove reads that I think are duplicates (multiple read pairs start and end in the same position with identical sequences).  You can search a RAW alignment, find some read pairs that are duplicates, then search the filtered alignment made with this setting set to "yes" to see if it does anything.

### no		samtools view -f 2 		Keep_only_properly_aligned_read_pairs? (yes,no)	

This sounds like a good thing to do, BUT, sometimes it can be too "proper".  For example, if BWA MEM decides the insert size is too long, then a read pair might be filtered that is perfectly fine.  It can be a good idea to experiment with this setting.  There are ways to adjust the "proper" insert size, but they are not straight forward, involves making calculations from your data, and beyond the scope here.  If you search the dDocentHPC source code, you'll find an example of this for RAD data.

### 0		samtools view -F 		Custom_samtools_view_F_bit_value? (integer)     					performed separately from the above, consult samtools man
### 0		samtools view -f 		Custom_samtools_view_f_bit_value? (integer)

These give you total control over the filters available in samtools.  Consult the samtools manual.

### 50		Remove_reads_with_alignment_score_below_relative_threshold (integer)	Alignment score thresholds are calculated based on this value adjusted by a factor (actual read length relative the assumed read length value in next setting). RelativeThreshold = as_threshold * actual_read_length / assumed_read_length, where this setting controls as_threshold. NOTE! bwa mem -T affects which reads are mapped based on alignment score, and therefore this filter cannot save reads elimated by bwa mem -T, but if the -T setting is too low then the RAW bam files can be huge.
### 100		Read_length_assumed_by_relative_alignment_score_threshold (integer)	Alignment score thresholds are calculated based on the threshold in the previous setting adjusted by a factor (actual read length relative the assumed read length value here). RelativeThreshold= as_threshold * actual_read_length / assumed_read_length, where this setting controls assumed_read_length

These two settings allow you to apply a read length aware filter of the alignment score.  They cannot recover reads that are removed with the `bwa mem -T` setting, but they can remove reads that passed the `bwa mem -T setting` (see mkBAM). Thus, these work in concert with `bwa mem -T` to filter your mapped reads by alignment score.  This is especialy important if you have reads of variable lengths because `bwa mem -T` alone causes short reads to have less heterozygosity than longer reads.  

The second value (100 `Read_length_assumed_by_relative_alignment_score_threshold`) controls the meaning of the first value (50 `Remove_reads_with_alignment_score_below_relative_threshold`).   These values work together to define the threshold alignment score (50) for reads of a given length (100), then the theshold is adjusted proportionately for all read lengths.  

Example 1: With the default values of 50 and 100, 10 mismatches are allowed in a 100 bp read (10%).  100 - (A+B) * 100 * 0.10 = 50, where A is the match score from mkBAM and B is the mismatch penalty from mkBAM.  If you have reads that are N bp, the threshold will automatically adjust to N - (A+B) * N  * 0.10 

Example 2: Let's say that you wanted your values to match the default for bwa mem -T and we assume that they intended that setting to be applied to 150 bp reads. Change the 50 to 30.  Change the 100 to 150.  Now, 150 - (A+B) * 150 * 0.16 = 30.  If you have reads that are N bp, the threshold will automatically adjust to N - (A+B) * N  * 0.16.  

--- 

## Map reads to reference

Run [`dDocentHPC.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC.sbatch) to map, filter the resulting bam files, and call variable sites.

```sh
cd YOUR_SPECIES_DIR/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch dDocentHPC.sbatch fltrBAM config.6.cssl
```

---

### Merging .bam files from multiple runs

If you are working with multiple sequencing runs, you should first map sequencing data from each run to your reference, then merge the .bam files using the `runmerge_2runs_cssl_array` scripts.

Note that these scipts assume you have two separate folders named 1st_sequencing_run and 2nd_sequencing_run in your species folder, and that the .bam files are in folders named mkBAM within each of these.

To run the merge script:

```
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash <path to species cssl folder> <3-letter species code> 
```

This will create another folder (<species cssl folder>/mergebams_run1run2) containing the merged .bam files, as well as 3 lists of individuals that were sequenced in run 1 only, run 2 only, and the merged individuals that were sequenced in run 1 and 2 together.

If you are working with >2 sequencing runs the script will need to be modified - contact Brendan if you need to do so!

In order for the merged .bam files to be interpreted correctly by dDocent the read group information will have to be modified to include only a single group. The `merge_fixrg_array` scripts should thus be run before proceeding.

To run the fixrg script:

```
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/ <path to directory with merged bam files>
```

After merging you can use these merged .bam files with the unmerged files from run 1 or run 2 only in downstream steps (mkVCF and fltrVCF).


## Generate Mapping Stats for Capture Targets with `getBAITcvg.sbatch` and `mappedReadStats.sbatch`

Move into the mkBAM dir and execute both scripts

```bash
cd <path/to/cssl/species dir/mkBAM dir>

# getBAITcvg.sbatch <Path to BAM file dir> <path to bedfile>
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/getBAITcvg.sbatch . /home/e1garcia/shotgun_PIRE/pire_probe_sets/<speciesDir>/<prefix>.singleLine.bed

# mappedReadStats.sbatch <Path to BAM file dir> <coverageMappedReads>
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/mappedReadStats.sbatch . coverageMappedReads
```

***NOTE:*** Sometimes the scripts don't compute all files. Thus, check the output to make sure you have output for all input BAM files. 

* `getBAITcvg.sbatch` will give you 2 out files per input BAM file.

* `mappedReadStats.sbatch` will output a single file. Check that you have the same number of lines (excluding the header) than number of input BAM files.

---

## Run mapDamage

Run `runMapdamage2.sbatch`.

```sh
cd YOUR_SPECIES_DIR/mkBAM

#this script has to be run from the dir with the FILTERED (.RG.bam) bam files
sbatch runMapdamage2.sbatch
```

--

## Run mkVCF

Run [`dDocentHPC.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC.sbatch) to call variable sites.

```sh
cd YOUR_SPECIES_DIR/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch dDocentHPC.sbatch mkVCF config.6.cssl
```

--

## Filter the `VCF` file


Make a filtering directory. 

```sh
cd YOUR_SPECIES_DIR

mkdir filterVCF
```

Clone the [`fltrVCF`](https://github.com/cbirdlab/fltrVCF) and [`rad_haplotyper`](https://github.com/cbirdlab/rad_haplotyper) repos and copy `config.fltr.ind.cssl` over to `filterVCF`.

  * If you have previously cloned either of these repos, just pull any of the latest changes with `git pull`. If you are working out of Eric's `shotgun_PIRE` dir, they are already cloned.

```sh
cd pire_cssl_data_processing/scripts

git clone https://github.com/cbirdlab/fltrVCF.git
git clone https://github.com/cbirdlab/rad_haplotyper.git


cd YOUR_SPECIES_DIR/filterVCF
cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Update the `config.fltr.ind.cssl` file with file paths and file extensions based on your species. Remove any filters that aren't run in this step (from the `fltrVCF -f` line). **You will only run up to the second 07 filter (remove filters 18 & 17 from the list of filters to run).**

Example of `config.fltr.ind.cssl` for Gmi:

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07               # order to run filters in
        fltrVCF -c rad.RAW-10-10                               # cutoffs, ie ref description
        fltrVCF -b ../mkBAM                                                                  # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
        fltrVCF -d ../mkBAM/mapped.rad.RAW-10-10.bed           # bed file used in genotyping
        fltrVCF -v TotalRawSNPs.rad.RAW-10-10.noindvless100Kseq.vcf  # vcf file to filter
        fltrVCF -g ../mkBAM/reference.rad.RAW-10-10.fasta      # reference genome
        fltrVCF -p ../mkBAM/popmap.rad.RAW-10-10                # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Gmi.A                                                                    # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```

You can leave the filter settings as the default for now, but you may need to adjust some settings based on your output (e.g. make some filters more or less stringent if large numbers of SNPs are being removed, etc.).

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd YOUR_SPECIES_DIR/filterVCF

#before running, make sure the config file is updated with file paths and file extensions based on your species
#config file should ONLY run up to the second 07 filter (remove filters 18 & 17 from list of filters to run)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl

#troubleshooting will be necessary
 ```
 
 ---
 
 ## Check for cryptic species
 
 Run PCA and ADMIXTURE to identify any cryptic species/population structure in your data. More information on what PCA & ADMIXTURE are, and how to run them (along with other population genetic analyses) can be found [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/).
 
 Make a `population_structure` directory and copy your filtered VCF file there.
 
 ```sh
 cd YOUR_SPECIES_DIR
 
 mkdir pop_structure
 cd pop_structure
 
 #copy final VCF file made from fltrVCF step to `pop_structure` directory
 cp ../filterVCF/<FINAL VCF> .
 ```
 
 Run PCA using PLINK. Instructions for installing Plink with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).
 
 ```sh
 cd YOUR_SPECIES_DIR/pop_structure
 
 #create your conda popgen environment and install PLINK
 
 module load anaconda
 conda activate popgen
 
 plink --vcf <YOUR VCF> --allow-extra-chr --pca --out PIRE.<SP 3 letter code>.<LOC>.preHWE 
 
 #example for Gmi
 plink --vcf Gmi.A.rad.RAW-10-10.Fltr07.18.vcf --allow-extra-chr --pca --out PIRE.Gmi.Ham.preHWE
 
 conda deactivate
 ```
 
 Make input files for ADMIXTURE with PLINK.
 
 ```sh
 cd YOUR_SPECIES_DIR/pop_structure

module load anaconda
conda activate popgen

plink --vcf <YOUR VCF> --allow-extra-chr --make-bed --out PIRE.<SP 3 letter code>.<LOC>.preHWE 
awk '{$1=0;print $0}' PIRE.<SP 3 letter code>.<LOC>.preHWE.bim > PIRE.<SP 3 letter code>.<LOC>.preHWE.bim.tmp
mv PIRE.<SP 3 letter code>.<LOC>.preHWE.bim.tmp PIRE.<SP 3 letter code>.<LOC>.preHWE.bim

#Example for Gmi
plink --vcf Gmi.A.rad.RAW-10-10.Fltr07.18.vcf --allow-extra-chr --make-bed --out PIRE.Gmi.Ham.preHWE
awk '{$1=0;print $0}' PIRE.Gmi.Ham.preHWE.bim > PIRE.Gmi.Ham.preHWE.bim.tmp
mv PIRE.Gmi.Ham.preHWE.bim.tmp PIRE.Gmi.Ham.preHWE.bim

conda deactivate
```

Run ADMIXTURE (K = 1-5). Instructions for installing ADMIXTURE with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).

```sh
cd YOUR_SPECIES_DIR/pop_structure

module load anaconda
conda activate popgen

admixture PIRE.<SP 3 letter code>.<LOC>.preHWE.bed 1 --cv > PIRE.<SP 3 letter code>.<LOC>.preHWE.log1.out #run from 1-5

#Example for Gmi
admixture PIRE.Gmi.Ham.preHWE.bed 1 --cv > PIRE.Gmi.Ham.preHWE.log1.out #run from 1-5

conda deactivate
```

Copy your `*.eigenval`, `*.eigenvec` & `*Q` files to your local computer. Run [`pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/pop_structure.R) on your local computer to visualize your PCA & ADMIXTURE results and identify any cryptic population structure.

---

## Filter the `VCF` file for HWE

IF PCA & ADMIXTURE show cryptic structure, then you need to adjust the `popmap` file to reflect this.

```sh
cd YOUR_SPECIES_DIR/filterVCF

cp ../mkBAM/<POPMAP> ./<POPMAP>.HWEsplit

#change the second column (pop assignment) to match any cryptic structure that is present
#one easy way to do this is to add -A or -B to the end of the population assignment to assign individuals to group A or B
```

Make a copy of the `config.fltr.ind.cssl` file called `config.fltr.ind.cssl.HWE` with file paths and file extensions based on your species AND the new HWEsplit popmap (if applicable). The VCF path should point to the VCF made at the end of the previous filtering run (the file PCA & ADMIXTURE was run with). Remove any filters that aren't run in this step (from the `fltrVCF -f` line). **You will only run filters 18 & 17 (in that order).**

```sh
cd YOUR_SPECIES_DIR/filterVCF

cp config.fltr.ind.cssl ./config.fltr.ind.cssl.HWE
```

Example of `config.fltr.ind.cssl.HWE` for Gmi:

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 18 17               # order to run filters in
        fltrVCF -c rad.RAW-10-10                               # cutoffs, ie ref description
        fltrVCF -b ../mkBAM                                                                  # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
        fltrVCF -d ../mkBAM/mapped.rad.RAW-10-10.bed           # bed file used in genotyping
        fltrVCF -v Gmi.A.rad.RAW-10-10.Fltr07.18.vcf  # vcf file to filter
        fltrVCF -g ../mkBAM/reference.rad.RAW-10-10.fasta      # reference genome
        fltrVCF -p popmap.rad.RAW-10-10.HWEsplit                # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Gmi.A.HWE                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd YOUR_SPECIES_DIR/filterVCF

#before running, make sure the config file is updated with file paths and file extensions based on your species
#popmap path should point to popmap file (*.HWEsplit) just made (if cryptic structure detected)
#vcf path should point to vcf made at end of previous filtering run (the file PCA & ADMIXTURE was run with)
#config file should ONLY run filters 18 & 17 (in that order)
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.HWE

#troubleshooting will be necessary
```

You can leave the filter settings as the default for now, but you may need to adjust some settings based on your output (e.g. make some filters more or less stringent if large numbers of SNPs are being removed, etc.).

***Congratulations!!*** *You have now finished the CSSL pipeline. Analyze your data to your heart's content.*

---

## C. OPTIONAL STEPS

The following steps are optional, and are useful mainly if you want to create an "all sites" VCF (one with both polymorphic and monomorphic sites) and/or calculate pi (nucleotide diversity).

## Make a `VCF` file with monomorphic loci

Create a `mkVCF_monomorphic` dir to make an "all sites" VCF (with monomorphic loci included) and move necessary files over.

**NOTE:** You may want to run these steps in `scratch`, as the "all sites" VCF and intermediate files can be fairly large in size (sometimes close to 1 TB!!).

```sh
cd YOUR_SPECIES_DIR

mkdir mkVCF_monomorphic

mv mkBAM/*bam* mkVCF_monomorphic
mv mkBAM/*fasta mkVCF_monomorphic
mv mkBAM/config.5.cssl mkVCF_monomorphic/config.5.cssl.monomorphic
```

Change the `config.5.cssl.monomorphic` file so that the last setting (monomorphic) is set to yes.

Example:

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles,
```

Genotype with [dDocentHPC_mkVCF.sbatch](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC_mkVCF.sbatch).

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

sbatch ../../scripts/dDocentHPC_mkVCF.sbatch config.5.cssl.monomorphic
```

---

## Filter the VCF with monomorphic loci

Set-up filtering the monomorphic and polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, it is probably best to do this in `scratch`.

First, set-up filtering for monomorphic sites only. Copy the `config.fltr.ind.cssl.mono` file over.

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

cp ../../scripts/config.fltr.ind.cssl.mono .
```

Update the `config.fltr.ind.cssl.mono` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made. **The settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file.**

Example of `config.fltr.ind.cssl.mono` for Gmi:

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
	fltrVCF -f 01 02 04 14 05 16 04 13 05 16 17                  # order to run filters in
	fltrVCF -c rad.RAW-10-10                               # cutoffs, ie ref description
	fltrVCF -b /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM                                                                  # path to *.bam files
	fltrVCF -R /home/r3clark/PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
	fltrVCF -d /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM/mapped.rad.RAW-10-10.bed           # bed file used in genotyping
	fltrVCF -v /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/TotalRawSNPs.rad.RAW-10-10.noindvless100Kseq.vcf          # vcf file to filter
        fltrVCF -g /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM/reference.rad.RAW-10-10.fasta      # reference genome
	fltrVCF -p /scratch/r3clark/PIRE-Gmi-Ham/mkVCF_monomorphic/popmap.rad.RAW-10-10.HWEsplit               # popmap file
	fltrVCF -w /home/r3clark/PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
	fltrVCF -r /home/r3clark/PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
	fltrVCF -o gmi.mono                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for monomorphic sites.

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.mono
```

Next, set-up filtering for polymorphic sites only. Make a `polymorphic_filter` directory in `mkVCF_monomorphic` and copy the `config.fltr.ind.cssl.poly` file over.

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

mkdir polymorphic_filter
cd polymorphic_filter

cp ../../scripts/config.fltr.ind.cssl.poly .
```

Update the `config.fltr.ind.cssl.poly` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made AND the HWEsplit popmap you made if you had any cryptic population structure. **The settings for all your filters should match the settings used when filtering the original VCF file.**

Example of `config.fltr.ind.cssl.poly` for Gmi:

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
	fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07 18 17                  # order to run filters in
	fltrVCF -c rad.RAW-10-10                               # cutoffs, ie ref description
	fltrVCF -b /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM                                                                  # path to *.bam files
	fltrVCF -R /home/r3clark/PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
	fltrVCF -d /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM/mapped.rad.RAW-10-10.bed           # bed file used in genotyping
	fltrVCF -v /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/TotalRawSNPs.rad.RAW-10-10.noindvless100Kseq.vcf          # vcf file to filter
        fltrVCF -g /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/mkBAM/reference.rad.RAW-10-10.fasta      # reference genome
	fltrVCF -p /scratch/r3clark/PIRE-Gmi-Ham/mkVCF_monomorphic/popmap.rad.RAW-10-10.HWEsplit               # popmap file
	fltrVCF -w /home/r3clark/PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
	fltrVCF -r /home/r3clark/PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
	fltrVCF -o gmi.poly                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for polymorphic sites.

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#popmap file should be the one that accounts for any cryptic structure, if it exists (*HWEsplit extension)
#settings should match the settings used when filtering the original VCF file
sbatch ../../../fltrVCF.sbatch config.fltr.ind.cssl.poly
```

## Merge monomorphic & polymorphic VCF files

Check the *filtered* monomorphic & polymorphic VCF files to make sure that filtering removed the same individuals. If not, remove the necessary individuals from the relevant files. *Your monomorphic and polymorphic VCFs should have the EXACT same individuals present. If not, merging will not work!*

  * To see which individuals have been removed, you can look at the `*.out` files created during filtering.
  * For an example of how to remove these individuals, look at the Gmi README.md file (Step 14).

Next, sort each VCF file.

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

module load vcftools

vcf-sort <NOMISSING MONOMORPHIC VCF> > <NOMISSING MONOMORPHIC VCF>.sorted.vcf
vcf-sort <NOMISSING POLYMORPHIC VCF> > <NOMISSING POLYMORPHIC VCF>.sorted.vcf

#Example for Gmi:
vcf-sort gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.vcf > gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf
vcf-sort gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.vcf > gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf
```

Zip each VCF file.

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

module load samtools/1.9

bgzip -c <MONOMORPHIC SORTED VCF> > <MONOMORPHIC SORTED VCF>.gz
bgzip -c <POLYMORPHIC SORTED VCF> > <POLYMORPHIC SORTED VCF>.gz

#Example for Gmi
bgzip -c gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf > gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz
bgzip -c gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf > gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Index each VCF file.

```sh
cd YOUR_SPECIESS_DIR/mkVCF_monomorphic

module load samtools/1.9

tabix <MONOMORPHIC SORTED VCF.GZ>
tabix <POLYMORPHIC SORTED VCF.GZ>

#Example for Gmi
tabix  gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz
tabix  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

```sh
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

crun bcftools concat --allow-overlaps  <MONOMORPHIC SORTED VCF.GZ>  <POLYMORPHIC SORTED VCF.GZ> -O z -o <spp 3 letter code>.all.recode.sorted.vcf.gz
tabix <spp 3 letter code>.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses

#Example for Gmi
crun bcftools concat --allow-overlaps  gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz -O z -o gmi.all.recode.nomissing.sorted.vcf.gz

</p>
</details>
tabix gmi.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses
```

That's it!

</p>
</details>
