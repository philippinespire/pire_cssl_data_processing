# CAPTURE SHOTGUN DATA PROCESSING & ANALYSIS

---

The purpose of this repo is to document the processing and analysis of `Capture Sequencing Libraries - CSSL data` for the Philippines PIRE Project. These data were generated using probes that resulted from the [Shotgun Sequencing Libraries - SSL repo](https://github.com/philippinespire/pire_ssl_data_processing). Both CSSL and SSL pipelines use scripts from the [Pre-Processing PIRE Data](https://github.com/philippinespire/pire_fq_gz_processing) repo at the beginning of files processing.  

For now, each species will get it's own directory in the repo.  Try to avoing putting dirs inside dirs inside dirs.  

**The Gmi dir (all steps) & Tzo dir (through genotyping) will serve as the examples to follow in terms of both directory structure and documentation of progress in `README.md`. The `README.md` structure for your species should follow this format as closely as possible.**

Contact Dr. Eric Garcia for questions or if you are having issues running scripts (e1garcia@odu.edu).

---

## Use Git/GitHub to Track Progress

To process a species, begin by cloning this repo to your working dir. I recommend setting up a shotgun_PIRE sub-dir in your home dir if you have not done something similar already.

Example: `/home/youruserID/shotgun_PIRE/`

Clone this repo

```
cd ~ #this will take you to your home dir
cd shotgun_PIRE
git clone https://github.com/philippinespire/pire_ssl_data_processing.git

#you can also work out of Eric's shotgun_PIRE directory if you want to save space. (/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing)
```

The data will be processed and analyzed in the repo.  There is a `.gitignore` file that lists files and directories to be ignored by git.  It includes large files that git cannot handle (fq.gz, bam, etc) and other repos that might be downloaded into this repo.  For example, the dir `dDocentHPC` contains the [dDocentHPC](https://github.com/cbirdlab/dDocentHPC) repo which you will be using, but we don't need to save that to this repo, so `dDocentHPC/` occurs in  `.gitignore` so that it is not uploaded to GitHub in this repo.

Because large data files will not be saved to GitHub, they will reside in an individual's copy of the repo or somewhere on the HPC. You should provide paths (absolute/full paths are probably best) or info that make it clear where the files reside. Most of these large intermediate files should be deleted once it is confirmed that they worked. For example, we don't ultimately need the intermediate files produced by fastp, clumpify, fastq_screen, etc.

A list of ongoing CSSL projects can be found below. If you are working on a CSSL analysis project (or if you wish to claim a project), please indicate so in the table.

|Species | Data availability | Analysis lead | Analysis status / notes |
| --- | --- | --- | --- |
|Aen | On ODU HPC | Rene | Pop gen (ongoing) |
|Gmi | On ODU HPC | Rene | Pop gen (ongoing) |
|Lle | On ODU HPC | Rene | Pop gen (ongoing) |
|Sde | On ODU HPC | Eric | QC complete? |
|Leq | On ODU HPC | John + Brendan | QC started (fastp1 done as of 5/2) |
|Tbi | On ODU HPC | George | unfiltered VCF created (as of 5/27) |
|Tzo | On ODU HPC | Kyra | unfiltered VCF created (as of 5/10) |
|Hte | On ODU HPC | Brendan | Data generated with incorrect probes, some pops missing |
|Hmi | On ODU HPC | Ivan | QC needs to be done |

---

## Maintaining Git Repo

You must pull down the lated version of the repo everytime you sit down to work and push the changes you made everytime you walk away from the terminal.  The following order of operations when you sync the repo will minimize problems.

From your species directory, execute these commands manually or run the `runGit.sh` script (see below).

```
git pull
git add --all
git commit -m "insert message"
git push
```

This code has been compiled into the script [`runGIT.bash`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/runGIT.bash) thus you can just run this script BEFORE and AFTER you do anything in your species repo. You will need to provide the message of your commit in the command line. Example:

```
bash ../runGIT.bash "initiated Sgr repo"
```

You will need to enter your git credentials multiple times each time you run this script (or push any changes manually).

If you should be met with a conflict screen, you are in the archane `vim` editor.  You can look up instructions on how to interface with it. I typically do the following:

* hit escape key twice
* type the following
  `:quit!`
  
If you have to delete files for whatever reason, these deletions occurred in your local directory but these files will remain in the git memory if they had already entered the system (been pushed).

If you are in this situation, run these git commands manually, AFTER running the `runGIT.bash` as described above (or pulling manually). `add -u` will stage your deleted files, then you can commit and push.

Run this from the directory where you deleted files:

```
git add -u .
git commit -m "update deletions"
git push -u origin main
```
___

## Data Processing Roadmap

## A. PRE-PROCESSING SEQUENCES

## 1. Set up directories and data

First, create your `species dir` and subdirs `logs` and `raw_fq_capture`. You should also copy this [template README](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/README.md) to your species dir. As you move through the pipeline, you should edit the README with the specific code that you ran, as well as information about the quality of your data and any issues you encountered. The goal is that anyone could follow your steps exactly and end up with the same output at the end of the pipeline.

Example for Tzo:

```
cd YOUR_WORKING_DIR
#example: /home/r3clark/PIRE/pire_cssl_data_processing

mkdir taeniamia_zosterophora #this is your species dir
mkdir taeniamia_zosterophora/raw_fq_capture #this is where the raw fq.gz files will be copied
mkdir taeniamia_zosterophora/logs #this is where all out/log files will go

cd taeniamia_zosterophora
cp ../scripts/README.md .
```

Check your raw files: given that we use paired-end sequencing, you should have one pair of files (1 forward and 1 reverse) per library. This means that you should have the same number of forward (`*1.fq.gz` or `*f.fq.gz`) and reverse (`*2.fq.gz` or `r.fq.gz`) sequence files. If you don't have equal numbers for forward and reverse files, check with whoever provided the data to make sure there was no issues while transferring.

If you aren't sure where your raw species sequencing data is stored on the HPC, check the Slack channel for your species. Usually there is a thread detailing where the data was transferred to (it is often in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/your_species/raw_fq_capture`).

Example for Tzo:

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture

#check got back sequencing data for all individuals in decode file
ls | wc -l #208 files (2 additional files for README & decode.tsv = 206/2 = 103 individuals (R&F)

#compare this to number of lines in the decode.tsv file to make sure there every individual has sequencing data
wc -l Tzo_CaptureLibraries_SequenceNameDecode.tsv #104 lines (1 additional line for header = 103 individuals), checks out
```

Next, copy these raw files to your species dir (if you are working somewhere other than Eric's shotgun_pire dir). *This can take several hours.*

Example for Tzo:

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora

cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture/* raw_fq_capture/
```

Make a copy of your raw files in the longterm carpenter RC dir **ONLY** if one doesn't exist already (if you copied your data from the RC, a long-term copy already exists). *This can take several hours.*

Example:

```
cd /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing #you MUST be on the log-in node to access the RC storage

mkdir taeniamia_zosterophora #this is your species dir
mkdir taeniamia_zosterophora/raw_fq_capture

cp /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture/* taeniamia_zosterophora/raw_fq_capture/
```

Create a `README` in the `fq_raw_cssl` dir with the full path to the original raw files and necessary decoding info to find out which individuals these sequence files came from. This information is usually provided by Sharon Magnuson & Eric Garcia in the species slack channel.

Example for Tzo:

```
Transfer from TAMUCC to ODU
scp /work/hobi/GCL/20220323_PIRE_Tzo-Capture/* e1garcia@turing.hpc.odu.edu:/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_zosterophora/raw_fq_capture/

206 fq files + decode file

Slack post= March 23th 2022, species channel
```

---

## 2. Complete fq.gz preprocessing

Go to the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) repo and complete the steps then return here.

  * This includes running FASTQC, FASTP1, CLUMPIFY, FASTP2, FASTQ_SCREEN, and file re-pair scripts.
  * Make sure you are running the **CSSL** versions of any scripts when necessary.
  
---

## Set up mapping directory and get reference genome
    * Best genome can be found by running [`wrangleData.R`](https://github.com/philippinespire/denovo_genome_assembly/tree/main/compare_assemblers), sorting tibble by busco or n50, and filtering by species 

4. Map reads, filter `bam` files and genotype
    * Use [`dDocentHPC`](https://github.com/cbirdlab/dDocentHPC)
      * Use [`config.5.cssl`](https://github.com/cbirdlab/dDocentHPC/blob/master/configs/config.5.cssl) when running dDocentHPC as a starting point for the settings

5. Filter the `vcf` file
    * Use [`fltrVCF`](https://github.com/cbirdlab/fltrVCF)
      * Use [`config.fltr.ind.cssl`](https://github.com/cbirdlab/fltrVCF/blob/master/config_files/config.fltr.ind.cssl) as a starting point for filter settings
      * Only run up to the second Filter 07

6. Check for cryptic species
   * Run PCA & ADMIXTURE to look for cryptic speciation
   * Instructions in [`pire_cssl_data_processing/scripts/popgen_analyses/`](https://github.com/philippinespire/pire_cssl_data_processing/tree/main/scripts/popgen_analyses)

7. Filter the `vcf` file for HWE
   * Update popmap file based on results from Step 9
   * Run Filters 18 & 17 in [`config.fltr.ind.cssl`](https://github.com/cbirdlab/fltrVCF/blob/master/config_files/config.fltr.ind.cssl)

8. OPTIONAL: Make `vcf` with monomorphic loci

9. OPTIONAL: Filter monomorphic `vcf`

10. OPTIONAL: Assess changes in diversity, population structure, etc. through time
    * Follow scripts/code in [`pire_cssl_data_processing/scripts/popgen_analyses/`](https://github.com/philippinespire/pire_cssl_data_processing/tree/main/scripts/popgen_analyses)
