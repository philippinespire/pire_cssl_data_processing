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

## B. MAPPING & FILTERING DATA

## Set up mapping directory and get reference genome

Make a mapping directory and move the re-paired `*fq.gz` files over. 

```
cd YOUR_SPECIES_DIR

mkdir mkBAM
mv fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkBAM
```

Clone the [`dDocentHPC`](https://github.com/cbirdlab/dDocentHPC) repo and copy `config.5.cssl` over to `mkBAM`.

  * If you have previously cloned `dDocentHPC` just pull any of the latest changes with `git pull`. If you are working out of Eric's `shotgun_PIRE` dir, `dDocentHPC` is already cloned.

```
cd pire_cssl_data_processing/scripts

git clone https://github.com/cbirdlab/dDocentHPC.git

cd YOUR_SPECIES_DIR/mkBAM
cp ../../scripts/dDocentHPC/configs/config.5.cssl .
```

**IF YOUR SPECIES HAS AN ASSEMBLED GENOME:** *(most species)* Find the best genome by running [`wrangleData.R`](https://github.com/philippinespire/denovo_genome_assembly/blob/main/compare_assemblers/wrangle_data.R) and sorting the tibble by (1) BUSCO single copy complete and (2) QUAST n50. Then filter by species in RStudio. *You can also look at the README of your species in the SSL directory (pire_ssl_data_processing) - the best genome should be listed there as well.* 

**IF YOUR SPECIES DOES NOT HAVE AN ASSEMBLED GENOME:** *(species where probes came from RAD data)* Find the "raw" reference fasta that was used for probe development (it will be the `*probes4development.fasta` that has NOT been filtered) and use that as your "best assembly" for mapping. You may have to dig through the Slack channel for your species and contact the individual responsible for creating this file to identify its location.

  * Should only apply to the following species: *Atherinomorus endrachtensis*, *Gazza minuta*, *Leiognathus equula*,  and *Spratelloides delicatulus*
    * *Ambassis urotaenia*, *Leiognathus leuciscus*, and *Siganus spinus* also had probes made from RAD data but have a whole genome assembly to map to

Copy the best genome to `mkBAM`. Rename in the process.

Example for Tzo:

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/taeniamia_zosterophora/mkBAM

cp /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/taeniamia_zosterophora/probe_design/Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta .

#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv Tzo_scaffolds_TzC0402G_contam_R1R2_noIsolate.fasta ./reference.ssl.Tzo-C-0402G-R1R2-contam-noisolate.fasta
```

Update `config.5.cssl` with the reference genome assembly information. You only need to udpdate the `mkREF` section.

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

## Map reads to reference - Filter maps - Genotype maps

Run `dDocentHPC.sbatch` to map, filter the resulting bam files, and call variable sites.

```
cd YOUR_SPECIES_DIR/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch ../../scripts/dDocentHPC.sbatch config.5.cssl
```

---

## Filter the `VCF` file


Make a filtering directory. 

```
cd YOUR_SPECIES_DIR

mkdir filterVCF
```

Clone the [`fltrVCF`](https://github.com/cbirdlab/fltrVCF) and [`rad_haplotyper`](https://github.com/cbirdlab/rad_haplotyper) repos and copy `config.fltr.ind.cssl` over to `filterVCF`.

  * If you have previously cloned either of these repos, just pull any of the latest changes with `git pull`. If you are working out of Eric's `shotgun_PIRE` dir, they are already cloned.

```
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

Run `fltrVCF.sbatch`.

```
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
 
 ```
 cd YOUR_SPECIES_DIR
 
 mkdir pop_structure
 cd pop_structure
 
 #copy final VCF file made from fltrVCF step to `pop_structure` directory
 cp ../filterVCF/<FINAL VCF> .
 ```
 
 Run PCA using PLINK. Instructions for installing Plink with Conda are [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/popgen_analyses/README.md).
 
 ```
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
 
 ```
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

```
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

```
cd YOUR_SPECIES_DIR/filterVCF

cp ../mkBAM/<POPMAP> ./<POPMAP>.HWEsplit

#change the second column (pop assignment) to match any cryptic structure that is present
#one easy way to do this is to add -A or -B to the end of the population assignment to assign individuals to group A or B
```

Make a copy of the `config.fltr.ind.cssl` file called `config.fltr.ind.cssl.HWE` with file paths and file extensions based on your species AND the new HWEsplit popmap (if applicable). The VCF path should point to the VCF made at the end of the previous filtering run (the file PCA & ADMIXTURE was run with). Remove any filters that aren't run in this step (from the `fltrVCF -f` line). **You will only run filters 18 & 17 (in that order).**

```
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

Run `fltrVCF.sbatch`.

```
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

```
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

Genotype.

```
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

sbatch ../../scripts/dDocentHPC_mkVCF.sbatch config.5.cssl.monomorphic
```

---

## Filter the VCF with monomorphic loci

Set-up filtering the monomorphic and polymorphic loci separately, then merge the VCFs together for one "all sites" VCF. Again, it is probably best to do this in `scratch`.

First, set-up filtering for monomorphic sites only. Copy the `config.fltr.ind.cssl.mono` file over.

```
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

Run `fltrVCF.sbatch` for monomorphic sites.

```
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.mono
```

Next, set-up filtering for polymorphic sites only. Make a `polymorphic_filter` directory in `mkVCF_monomorphic` and copy the `config.fltr.ind.cssl.poly` file over.

```
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

Run `fltrVCF.sbatch` for polymorphic sites.

```
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

```
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

module load vcftools

vcf-sort <MONOMORPHIC VCF> > <MONOMORPHIC VCF EXT>.sorted.vcf
vcf-sort <POLYMORPHIC VCF> > <POLYMORPHIC VCF EXT>.sorted.vcf

#Example for Gmi:
vcf-sort gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.vcf > gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf
vcf-sort gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.vcf > gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf
```

Zip each VCF file.

```
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

module load samtools/1.9

bgzip -c <MONOMORPHIC SORTED VCF> > <MONOMORPHIC SORTED VCF>.gz
bgzip -c <POLYMORPHIC SORTED VCF> > <POLYMORPHIC SORTED VCF>.gz

#Example for Gmi
bgzip -c gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf > gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz
bgzip -c gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf > gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Index each VCF file.

```
cd YOUR_SPECIESS_DIR/mkVCF_monomorphic

module load samtools/1.9

tabix <MONOMORPHIC SORTED VCF.GZ>
tabix <POLYMORPHIC SORTED VCF.GZ>

#Example for Gmi
tabix  gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz
tabix  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

```
cd YOUR_SPECIES_DIR/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

crun bcftools concat --allow-overlaps  <MONOMORPHIC SORTED VCF.GZ>  <POLYMORPHIC SORTED VCF.GZ> -O z -o <spp 3 letter code>.all.recode.sorted.vcf.gz
tabix <spp 3 letter code>.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses

#Example for Gmi
crun bcftools concat --allow-overlaps  gmi.mono.rad.RAW-10.10.Fltr17.11.recode.nomissing.sorted.vcf.gz  gmi.poly.rad.RAW-10.10.Fltr17.20.recode.nomissing.sorted.vcf.gz -O z -o gmi.all.recode.nomissing.sorted.vcf.gz
tabix gmi.all.recode.nomissing.sorted.vcf.gz #index all sites VCF for downstream analyses
```

That's it!
