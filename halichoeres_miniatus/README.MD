# Log for Halichoeres Miniatus

The purpose of this log is to create replicable steps for the processing and analysis of capture shotgun sequencing library data (cssl) for *H. miniatus* as outlined by Dr. Eric Garcia in the [PIRE CAPTURE SHOTGUN DATA PROCESSING & ANALYSIS Page](https://github.com/philippinespire/pire_cssl_data_processing) of the [PhilippinesPIRE](https://github.com/philippinespire) repository.  All scripts and software used are explained on the PIRE Shotgun repository.  All bioinformatic work was performed on the Old Dominion University (ODU) High Performance Computing Cluster (HPC).  The log and worked performed here was completed by Ivan Lopez, MS, ODU.  I received assitance with scripting from Mr. Min Dong, MS, ODU.

The documents in this repository are written in [Markdown](https://www.markdownguide.org/basic-syntax/#links).

All work is done for the [Philippines PIRE Project](https://sites.wp.odu.edu/PIRE/), [NSF Award #1743711](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1743711).

See documentation for the ODU [HPC](https://www.odu.edu/facultystaff/research/resources/computing/high-performance-computing/user-documentation).

The main repo is on ODU HPC /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/

A complete log of all Command Line interface (CLI) work is below.

***

## Preliminary

I cleared all data and compressed and stored all directories as applicable to have as much room as possible on my home directory on the HPC.  I have set my user name and email to my git config global file. I recommend [Software Carpentry Version Control with Git](https://swcarpentry.github.io/git-novice/) for instructions, see module 2. I previously edited my .bashrc profile on the HPC so `module load git` is always executed.  This can be done on Wahab and Turing by typing `nano ~/.wahab_tcshrc` or `nano ~/.turing_tcshrc` on the CLI and making the proper edit to the file.

I typed the following commands:

```sh
cd ~
mkdir pire_cssl_data_processing
cd pire_cssl_data_processing
git init
git remote add origin https://github.com/philippinespire/pire_cssl_data_processing
git config --add core.sparseCheckout true
git sparse-checkout set halichoeres_miniatus
git pull origin main
```

The halichores\_miniatus subdir pulled to my dir on HPC /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/

I typed the following commands:

```sh
git add ./*
git commit -m "updated README with Preliminary"
git push -u origin main
```

Further git commands will be executed with the following script /home/ilope002/scripts/Gitpushinator.sh:

```sh
#!/bin/bash -l

git pull
git add ./* 
git commit -m "$1"
git push -u origin main
```

***

## fq.gz Preprocessing

I began the protocol outlined by Rene Clark to process raw fq files for cssl which can be found in the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) repo.  These scripts will trim, deduplicate, decontaminate, and repair the raw fq.gz files.

I ran the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing/
cp -r /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/ .
mkdir logs
cd halichoeres_miniatus
```

I will run scripts as follows:

```sh
sbatch /home/ilope002/shotgun_PIRE/pire_fq_gz_processing/
``

Since these scripts are not cloned from the remote and are copied from Dr. Garcia's repo, I will edit them locally without affecting the originals.

I edited the renamFQGZ.bash script by inserting lines as follows:

```sh
#SBATCH --exclusive
#SBATCH --mail-user=ilope002@odu.edu
#SBATCH --mail-type=END
#SBATCH --job-name=RenameFQGZ
#SBATCH --output=/home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/logs/Rename.out
#SBATCH --open-mode=append

echo "SLURM_JOB_ID=$SLURM_JOB_ID"

```

The file for renaming is Hmi_CaptureLibraries_SequenceNameDecode.tsv

After following the repo's instructions to cp /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/fq_raw_cssl to my working dir, I received an error message.  I observed this dir did not exist.  Checking and email with the pathway for the raw files, I observed there were no files at /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/.

I will have to confer with my collegues for the location of the raw files.

While I received no answer to emails since all staff is in the filed, on the 5th of July I discovered the 374 raw data files for *H. miniatus* and copied them.  I verified the files were copied to the correct directory.  The instructions recommend copying the raw files to the /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/fq_raw_cssl.  This dir is very small.  I will skip this step since the raw files are already at /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture and also at /home/ilope002/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture

I typed the following commands:

```sh
cd /home/ilope002/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture
salloc
bash ../../../fq_gz_processing/renameFQGZ.bash Hmi_CaptureLibraries_SequenceNameDecode.tsv rename
y
y
```
It is not apparent to me that this script did anything.  While two .txt files were generated, if the script was supposed to rename the libraries, that does not appear to have happened.  SLURM did not send an email when the script completed, or create a log.  I wonder if adding SLURM commands created a conflict with bash.  I deleted the SLURM commands and ran the script again.  The file names remained unchanged.

I confered with my colleagues who reported a recent Perl binary error in Wahab that was preventing the scripts from executing properly.  A solution was found but was not yet pushed to the repo.  This error will affect the performance of several scripts.  I will continue this work once the problem is resolved.

### Rename

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "renameFQGZ.bash failed"
```

Rene Clark explained that likely I was preloading a module my `~/.wahab_tcshrc` profile that was creating a Perl binary conflict as older modules will call older versions of Perl.  I was preloading the following modules: git, slurm, parallel, agrep, tre, python, bedtools2/2.27.1, vcftools/0.1.14.  I edited the file to only load git and slurm.

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "Trouble shooting Perl binary error"

I typed the following commands:

```sh
cd /home/ilope002/shotgun_PIRE/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture
salloc
bash ../../../fq_gz_processing/renameFQGZ.bash Hmi_CaptureLibraries_SequenceNameDecode.tsv rename
y
y
```

The script did not change the file names as expected.  The original names were retained.  I reported the error to my colleagues and requested guidance.  It seems to me that understanding the purpose of the script is crucial.  The script should rename the library file from the original sequencing facility library name to a PIRE readable name that fits with our current sample naming scheme.  It is not explained what elements, if any of the sequencer name should be retained (although it seems logical that understanding which are forward reads and which are reverse reads is critical to proper assembly).  It is my opinion that it would be better to explain to the researcher what the new file names should look like first.  I would start by explaining a standardized replicable naming scheme to be used for all libraries.  I would the explain the elements of the new name and how to create each element.  I would then explain the elements of the old name and which of those elements should be retained.  Then I would give a hypothetical example and a real example of a file that was renamed.  The reason that I would do this is that researchers creating these scripts will move on to other opportunities or graduate.  Wahab and Turing are dynamic HPCs.  A script that runs smoothly today, may fail tomorrow.  Leaving out clear explicit descriptions of function makes scripts esoteric and hinders replicability.  It seems to me that if I clearly understood how the files should be renamed and which elements should be inserted, retained and removed, that I could easily do this with the mv command executed on a script.  for example:

```sh
#!/bin/bash
mv Old_Name_RetainableElement.fq.gz PIRE_NAME_RetainableElement.fq.gz
```

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "renameFQGZ.bash failed to rename"
```

Rene had success rename the files with the script found at /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/.  She recommended that I delete the dir I cp'd with the script for convenience and that I work out of /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/.  I deleted the directory at /home/ilope002/shotgun_PIRE/ that I cp'd from Eric's as above.

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Hmi_CaptureLibraries_SequenceNameDecode.tsv
```

The script returned the following error: enable_lmod: command not found.  The script generated two files bearing the same errors as before.

I typed the following commands:

```sh
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Hmi_CaptureLibraries_SequenceNameDecode.tsv rename
y
y
```

It was not possible to press return after typing y as the script moves very fast.  Rene advised me that pressing return would abort the script.  I recommended that another person try to rename the files in my home dir or that I devise another script for renaming.  I requested guidance on what the new names should look like.

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "/home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash failed to rename"
```

After conferring with Rene, she discovered that the problem with the *H. miniatus* data set is that there are multiple extractions for the same individual, for most of the specimens.  This was done at ODU after conferring with Sharon Magnuson and Dr. Bird at TAMU-CC.  In some species the original \[DNA\] after extraction was very low.  At ODU we resampled a higher mass of tissue from specimens to obtain a higher \[DNA\].  Because there are multiple libraries with nearly the same name, the script is unable to parse the renaming properly and the script fails.  Rene agreed with my suggestion to create a specific script to rename these files.

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture
touch filelist.txt
ls > filelist.txt
```

 An example for how the files should be renamed is 'mv HmC010011A_CKDL220009543-1a-AK9141-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_001-Ex1-01A_L3_1.fq.gz`. However there are two libraries for this specimen with forward and reverse reads as follows:
HmC010011A_CKDL220009543-1a-AK9141-7UDI214_HN325DSX3_L3_1.fq.gz
HmC010011A_CKDL220009543-1a-AK9141-7UDI214_HN325DSX3_L3_2.fq.gz
HmC010011D_CKDL220009543-1a-AK9141-AK7558_HN325DSX3_L3_1.fq.gz
HmC010011D_CKDL220009543-1a-AK9141-AK7558_HN325DSX3_L3_2.fq.gz
Which according to the decode file would be renamed to Hmi-CBas_001-Ex1-01A_L3_1|2.fq.gz. Two libraries would be overwritten.  I have to confer with my colleages to come up with a proper naming scheme that will not create problems further down the pipeline.  Once we have established a naming scheme I will create a script.
I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "potential file overwrite problem with renaming"
```

We found that the errors were in the decode file.  One sequence name variable was set for contemporary specimens for sequences belonging to separate individuals for example, the variable HmC01023, the 'key', is set to use replace the name of the forward and reverse read libraries for specimens Hmi-CBas_023-Ex1-12F and Hmi-CPar_023-Ex1-07H, two separate strings.  Because the original file names are HmC0102312F_CKDL220009543-1a-5UDI312-AK2587_HN325DSX3_L3_1.fq.gz, HmC0102312F_CKDL220009543-1a-5UDI312-AK2587_HN325DSX3_L3_2.fq.gz, HmC010237H_CKDL220009543-1a-AK8587-7UDI246_HN325DSX3_L3_1.fq.gz, and HmC010237H_CKDL220009543-1a-AK8587-7UDI246_HN325DSX3_L3_2.fq.gz the script cannot decide which key and string combination to use to rename.  Half the files in the decode file have this problem.  I tested this with dummy files and with a value lookup function on excel.  This work is ommited here as it was for trouble shooting and not part of the pipeline.  The script failed to rename half the files due to not being able to properly fit a key to a string in the original file name.  I created the Renameinator.sh script using the decoder file, Hmi_CaptureLibraries_SequenceNameDecode.tsv and filelist.txt with [BBEdit](https://www.barebones.com/products/bbedit/) on Mac OS Monterey.  The script is as follows:


```sh
#!/bin/bash

#SBATCH --exclusive
#SBATCH --mail-user=ilopez@odu.edu
#SBATCH --mail-type=END
#SBATCH --job-name=RenameFQGZ
#SBATCH --output=/home/ilope002/pire_cssl_data_processing/logs/RenameFQGZbash.out
#SBATCH --open-mode=append

echo "SLURM_JOB_ID=$SLURM_JOB_ID"

mv HmA0100112D_CKDL220009543-1a-AK5577-AK7558_HN325DSX3_L3_1.fq.gz Hmi-AMac_001-Ex1-12D_L3_1.fq.gz
mv HmA0100112D_CKDL220009543-1a-AK5577-AK7558_HN325DSX3_L3_2.fq.gz Hmi-AMac_001-Ex1-12D_L3_2.fq.gz
mv HmA010011A_CKDL220009543-1a-5UDI301-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_001-Ex1-01A_L3_1.fq.gz
mv HmA010011A_CKDL220009543-1a-5UDI301-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_001-Ex1-01A_L3_2.fq.gz
mv HmA010021G_CKDL220009543-1a-5UDI301-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_002-Ex1-01G_L3_1.fq.gz
mv HmA010021G_CKDL220009543-1a-5UDI301-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_002-Ex1-01G_L3_2.fq.gz
mv HmA010022A_CKDL220009543-1a-AK7758-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_002-Ex1-02A_L3_1.fq.gz
mv HmA010022A_CKDL220009543-1a-AK7758-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_002-Ex1-02A_L3_2.fq.gz
mv HmA010032G_CKDL220009543-1a-AK7758-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_003-Ex1-02G_L3_1.fq.gz
mv HmA010032G_CKDL220009543-1a-AK7758-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_003-Ex1-02G_L3_2.fq.gz
mv HmA010033A_CKDL220009543-1a-AK7078-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_003-Ex1-03A_L3_1.fq.gz
mv HmA010033A_CKDL220009543-1a-AK7078-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_003-Ex1-03A_L3_2.fq.gz
mv HmA010043G_CKDL220009543-1a-AK7078-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_004-Ex1-03G_L3_1.fq.gz
mv HmA010043G_CKDL220009543-1a-AK7078-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_004-Ex1-03G_L3_2.fq.gz
mv HmA010044A_CKDL220009543-1a-AK9143-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_004-Ex1-04A_L3_1.fq.gz
mv HmA010044A_CKDL220009543-1a-AK9143-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_004-Ex1-04A_L3_2.fq.gz
mv HmA010054G_CKDL220009543-1a-AK9143-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_005-Ex1-04G_L3_1.fq.gz
mv HmA010054G_CKDL220009543-1a-AK9143-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_005-Ex1-04G_L3_2.fq.gz
mv HmA010055A_CKDL220009543-1a-5UDI225-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_005-Ex1-05A_L3_1.fq.gz
mv HmA010055A_CKDL220009543-1a-5UDI225-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_005-Ex1-05A_L3_2.fq.gz
mv HmA010065G_CKDL220009543-1a-5UDI225-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_006-Ex1-05G_L3_1.fq.gz
mv HmA010065G_CKDL220009543-1a-5UDI225-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_006-Ex1-05G_L3_2.fq.gz
mv HmA010066A_CKDL220009543-1a-AK9144-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_006-Ex1-06A_L3_1.fq.gz
mv HmA010066A_CKDL220009543-1a-AK9144-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_006-Ex1-06A_L3_2.fq.gz
mv HmA010076G_CKDL220009543-1a-AK9144-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_007-Ex1-06G_L3_1.fq.gz
mv HmA010076G_CKDL220009543-1a-AK9144-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_007-Ex1-06G_L3_2.fq.gz
mv HmA010077A_CKDL220009543-1a-AK3911-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_007-Ex1-07A_L3_1.fq.gz
mv HmA010077A_CKDL220009543-1a-AK3911-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_007-Ex1-07A_L3_2.fq.gz
mv HmA010087G_CKDL220009543-1a-AK3911-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_008-Ex1-07G_L3_1.fq.gz
mv HmA010087G_CKDL220009543-1a-AK3911-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_008-Ex1-07G_L3_2.fq.gz
mv HmA010088A_CKDL220009543-1a-5UDI245-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_008-Ex1-08A_L3_1.fq.gz
mv HmA010088A_CKDL220009543-1a-5UDI245-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_008-Ex1-08A_L3_2.fq.gz
mv HmA010098G_CKDL220009543-1a-5UDI245-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_009-Ex1-08G_L3_1.fq.gz
mv HmA010098G_CKDL220009543-1a-5UDI245-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_009-Ex1-08G_L3_2.fq.gz
mv HmA010099A_CKDL220009543-1a-AK8593-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_009-Ex1-09A_L3_1.fq.gz
mv HmA010099A_CKDL220009543-1a-AK8593-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_009-Ex1-09A_L3_2.fq.gz
mv HmA0101010A_CKDL220009543-1a-5UDI294-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_010-Ex1-10A_L3_1.fq.gz
mv HmA0101010A_CKDL220009543-1a-5UDI294-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_010-Ex1-10A_L3_2.fq.gz
mv HmA010109G_CKDL220009543-1a-AK8593-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_010-Ex1-09G_L3_1.fq.gz
mv HmA010109G_CKDL220009543-1a-AK8593-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_010-Ex1-09G_L3_2.fq.gz
mv HmA0101110G_CKDL220009543-1a-5UDI294-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_011-Ex1-10G_L3_1.fq.gz
mv HmA0101110G_CKDL220009543-1a-5UDI294-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_011-Ex1-10G_L3_2.fq.gz
mv HmA0101111A_CKDL220009543-1a-AK9146-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_011-Ex1-11A_L3_1.fq.gz
mv HmA0101111A_CKDL220009543-1a-AK9146-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_011-Ex1-11A_L3_2.fq.gz
mv HmA0101211G_CKDL220009543-1a-AK9146-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_012-Ex1-11G_L3_1.fq.gz
mv HmA0101211G_CKDL220009543-1a-AK9146-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_012-Ex1-11G_L3_2.fq.gz
mv HmA0101212A_CKDL220009543-1a-AK5577-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-ABas_012-Ex1-12A_L3_1.fq.gz
mv HmA0101212A_CKDL220009543-1a-AK5577-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-ABas_012-Ex1-12A_L3_2.fq.gz
mv HmA0101312G_CKDL220009543-1a-AK5577-GC12_HN325DSX3_L3_1.fq.gz Hmi-AMac_013-Ex1-12G_L3_1.fq.gz
mv HmA0101312G_CKDL220009543-1a-AK5577-GC12_HN325DSX3_L3_2.fq.gz Hmi-AMac_013-Ex1-12G_L3_2.fq.gz
mv HmA010131B_CKDL220009543-1a-5UDI301-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_013-Ex1-01B_L3_1.fq.gz
mv HmA010131B_CKDL220009543-1a-5UDI301-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_013-Ex1-01B_L3_2.fq.gz
mv HmA010141H_CKDL220009543-1a-5UDI301-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_014-Ex1-01H_L3_1.fq.gz
mv HmA010141H_CKDL220009543-1a-5UDI301-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_014-Ex1-01H_L3_2.fq.gz
mv HmA010142B_CKDL220009543-1a-AK7758-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_014-Ex1-02B_L3_1.fq.gz
mv HmA010142B_CKDL220009543-1a-AK7758-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_014-Ex1-02B_L3_2.fq.gz
mv HmA010152H_CKDL220009543-1a-AK7758-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_015-Ex1-02H_L3_1.fq.gz
mv HmA010152H_CKDL220009543-1a-AK7758-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_015-Ex1-02H_L3_2.fq.gz
mv HmA010153B_CKDL220009543-1a-AK7078-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_015-Ex1-03B_L3_1.fq.gz
mv HmA010153B_CKDL220009543-1a-AK7078-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_015-Ex1-03B_L3_2.fq.gz
mv HmA010163H_CKDL220009543-1a-AK7078-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_016-Ex1-03H_L3_1.fq.gz
mv HmA010163H_CKDL220009543-1a-AK7078-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_016-Ex1-03H_L3_2.fq.gz
mv HmA010164B_CKDL220009543-1a-AK9143-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_016-Ex1-04B_L3_1.fq.gz
mv HmA010164B_CKDL220009543-1a-AK9143-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_016-Ex1-04B_L3_2.fq.gz
mv HmA010174H_CKDL220009543-1a-AK9143-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_017-Ex1-04H_L3_1.fq.gz
mv HmA010174H_CKDL220009543-1a-AK9143-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_017-Ex1-04H_L3_2.fq.gz
mv HmA010175B_CKDL220009543-1a-5UDI225-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_017-Ex1-05B_L3_1.fq.gz
mv HmA010175B_CKDL220009543-1a-5UDI225-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_017-Ex1-05B_L3_2.fq.gz
mv HmA010185H_CKDL220009543-1a-5UDI225-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_018-Ex1-05H_L3_1.fq.gz
mv HmA010185H_CKDL220009543-1a-5UDI225-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_018-Ex1-05H_L3_2.fq.gz
mv HmA010186B_CKDL220009543-1a-AK9144-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_018-Ex1-06B_L3_1.fq.gz
mv HmA010186B_CKDL220009543-1a-AK9144-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_018-Ex1-06B_L3_2.fq.gz
mv HmA010196H_CKDL220009543-1a-AK9144-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_019-Ex1-06H_L3_1.fq.gz
mv HmA010196H_CKDL220009543-1a-AK9144-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_019-Ex1-06H_L3_2.fq.gz
mv HmA010197B_CKDL220009543-1a-AK3911-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_019-Ex1-07B_L3_1.fq.gz
mv HmA010197B_CKDL220009543-1a-AK3911-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_019-Ex1-07B_L3_2.fq.gz
mv HmA010207H_CKDL220009543-1a-AK3911-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_020-Ex1-07H_L3_1.fq.gz
mv HmA010207H_CKDL220009543-1a-AK3911-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_020-Ex1-07H_L3_2.fq.gz
mv HmA010208B_CKDL220009543-1a-5UDI245-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_020-Ex1-08B_L3_1.fq.gz
mv HmA010208B_CKDL220009543-1a-5UDI245-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_020-Ex1-08B_L3_2.fq.gz
mv HmA010218H_CKDL220009543-1a-5UDI245-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_021-Ex1-08H_L3_1.fq.gz
mv HmA010218H_CKDL220009543-1a-5UDI245-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_021-Ex1-08H_L3_2.fq.gz
mv HmA010219B_CKDL220009543-1a-AK8593-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_021-Ex1-09B_L3_1.fq.gz
mv HmA010219B_CKDL220009543-1a-AK8593-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_021-Ex1-09B_L3_2.fq.gz
mv HmA0102210B_CKDL220009543-1a-5UDI294-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_022-Ex1-10B_L3_1.fq.gz
mv HmA0102210B_CKDL220009543-1a-5UDI294-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_022-Ex1-10B_L3_2.fq.gz
mv HmA010229H_CKDL220009543-1a-AK8593-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_022-Ex1-09H_L3_1.fq.gz
mv HmA010229H_CKDL220009543-1a-AK8593-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_022-Ex1-09H_L3_2.fq.gz
mv HmA0102310H_CKDL220009543-1a-5UDI294-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_023-Ex1-10H_L3_1.fq.gz
mv HmA0102310H_CKDL220009543-1a-5UDI294-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_023-Ex1-10H_L3_2.fq.gz
mv HmA0102311B_CKDL220009543-1a-AK9146-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_023-Ex1-11B_L3_1.fq.gz
mv HmA0102311B_CKDL220009543-1a-AK9146-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_023-Ex1-11B_L3_2.fq.gz
mv HmA0102411H_CKDL220009543-1a-AK9146-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_024-Ex1-11H_L3_1.fq.gz
mv HmA0102411H_CKDL220009543-1a-AK9146-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_024-Ex1-11H_L3_2.fq.gz
mv HmA0102412B_CKDL220009543-1a-AK5577-AK4971_HN325DSX3_L3_1.fq.gz Hmi-ABas_024-Ex1-12B_L3_1.fq.gz
mv HmA0102412B_CKDL220009543-1a-AK5577-AK4971_HN325DSX3_L3_2.fq.gz Hmi-ABas_024-Ex1-12B_L3_2.fq.gz
mv HmA0102512H_CKDL220009543-1a-AK5577-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-AMac_025-Ex1-12H_L3_1.fq.gz
mv HmA0102512H_CKDL220009543-1a-AK5577-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-AMac_025-Ex1-12H_L3_2.fq.gz
mv HmA010261E_CKDL220009543-1a-5UDI301-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_026-Ex1-01E_L3_1.fq.gz
mv HmA010261E_CKDL220009543-1a-5UDI301-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_026-Ex1-01E_L3_2.fq.gz
mv HmA010262C_CKDL220009543-1a-AK7758-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_026-Ex1-02C_L3_1.fq.gz
mv HmA010262C_CKDL220009543-1a-AK7758-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_026-Ex1-02C_L3_2.fq.gz
mv HmA010272E_CKDL220009543-1a-AK7758-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_027-Ex1-02E_L3_1.fq.gz
mv HmA010272E_CKDL220009543-1a-AK7758-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_027-Ex1-02E_L3_2.fq.gz
mv HmA010283E_CKDL220009543-1a-AK7078-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_028-Ex1-03E_L3_1.fq.gz
mv HmA010283E_CKDL220009543-1a-AK7078-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_028-Ex1-03E_L3_2.fq.gz
mv HmA010284C_CKDL220009543-1a-AK9143-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_028-Ex1-04C_L3_1.fq.gz
mv HmA010284C_CKDL220009543-1a-AK9143-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_028-Ex1-04C_L3_2.fq.gz
mv HmA010294E_CKDL220009543-1a-AK9143-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_029-Ex1-04E_L3_1.fq.gz
mv HmA010294E_CKDL220009543-1a-AK9143-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_029-Ex1-04E_L3_2.fq.gz
mv HmA010305E_CKDL220009543-1a-5UDI225-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_030-Ex1-05E_L3_1.fq.gz
mv HmA010305E_CKDL220009543-1a-5UDI225-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_030-Ex1-05E_L3_2.fq.gz
mv HmA010306C_CKDL220009543-1a-AK9144-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_030-Ex1-06C_L3_1.fq.gz
mv HmA010306C_CKDL220009543-1a-AK9144-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_030-Ex1-06C_L3_2.fq.gz
mv HmA010316E_CKDL220009543-1a-AK9144-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_031-Ex1-06E_L3_1.fq.gz
mv HmA010316E_CKDL220009543-1a-AK9144-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_031-Ex1-06E_L3_2.fq.gz
mv HmA010317C_CKDL220009543-1a-AK3911-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_031-Ex1-07C_L3_1.fq.gz
mv HmA010317C_CKDL220009543-1a-AK3911-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_031-Ex1-07C_L3_2.fq.gz
mv HmA010327E_CKDL220009543-1a-AK3911-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_032-Ex1-07E_L3_1.fq.gz
mv HmA010327E_CKDL220009543-1a-AK3911-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_032-Ex1-07E_L3_2.fq.gz
mv HmA010328C_CKDL220009543-1a-5UDI245-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_032-Ex1-08C_L3_1.fq.gz
mv HmA010328C_CKDL220009543-1a-5UDI245-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_032-Ex1-08C_L3_2.fq.gz
mv HmA010338E_CKDL220009543-1a-5UDI245-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_033-Ex1-08E_L3_1.fq.gz
mv HmA010338E_CKDL220009543-1a-5UDI245-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_033-Ex1-08E_L3_2.fq.gz
mv HmA010339C_CKDL220009543-1a-AK8593-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_033-Ex1-09C_L3_1.fq.gz
mv HmA010339C_CKDL220009543-1a-AK8593-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_033-Ex1-09C_L3_2.fq.gz
mv HmA0103410C_CKDL220009543-1a-5UDI294-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_034-Ex1-10C_L3_1.fq.gz
mv HmA0103410C_CKDL220009543-1a-5UDI294-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_034-Ex1-10C_L3_2.fq.gz
mv HmA010349E_CKDL220009543-1a-AK8593-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_034-Ex1-09E_L3_1.fq.gz
mv HmA010349E_CKDL220009543-1a-AK8593-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_034-Ex1-09E_L3_2.fq.gz
mv HmA0103510E_CKDL220009543-1a-5UDI294-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_035-Ex1-10E_L3_1.fq.gz
mv HmA0103510E_CKDL220009543-1a-5UDI294-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_035-Ex1-10E_L3_2.fq.gz
mv HmA0103611E_CKDL220009543-1a-AK9146-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_036-Ex1-11E_L3_1.fq.gz
mv HmA0103611E_CKDL220009543-1a-AK9146-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_036-Ex1-11E_L3_2.fq.gz
mv HmA0103612C_CKDL220009543-1a-AK5577-AK1864_HN325DSX3_L3_1.fq.gz Hmi-ABas_036-Ex1-12C_L3_1.fq.gz
mv HmA0103612C_CKDL220009543-1a-AK5577-AK1864_HN325DSX3_L3_2.fq.gz Hmi-ABas_036-Ex1-12C_L3_2.fq.gz
mv HmA0103712E_CKDL220009543-1a-AK5577-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-AMac_037-Ex1-12E_L3_1.fq.gz
mv HmA0103712E_CKDL220009543-1a-AK5577-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-AMac_037-Ex1-12E_L3_2.fq.gz
mv HmA010371D_CKDL220009543-1a-5UDI301-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_037-Ex1-01D_L3_1.fq.gz
mv HmA010371D_CKDL220009543-1a-5UDI301-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_037-Ex1-01D_L3_2.fq.gz
mv HmA010381F_CKDL220009543-1a-5UDI301-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_038-Ex1-01F_L3_1.fq.gz
mv HmA010381F_CKDL220009543-1a-5UDI301-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_038-Ex1-01F_L3_2.fq.gz
mv HmA010382D_CKDL220009543-1a-AK7758-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_038-Ex1-02D_L3_1.fq.gz
mv HmA010382D_CKDL220009543-1a-AK7758-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_038-Ex1-02D_L3_2.fq.gz
mv HmA010392F_CKDL220009543-1a-AK7758-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_039-Ex1-02F_L3_1.fq.gz
mv HmA010392F_CKDL220009543-1a-AK7758-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_039-Ex1-02F_L3_2.fq.gz
mv HmA010393D_CKDL220009543-1a-AK7078-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_039-Ex1-03D_L3_1.fq.gz
mv HmA010393D_CKDL220009543-1a-AK7078-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_039-Ex1-03D_L3_2.fq.gz
mv HmA010403F_CKDL220009543-1a-AK7078-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_040-Ex1-03F_L3_1.fq.gz
mv HmA010403F_CKDL220009543-1a-AK7078-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_040-Ex1-03F_L3_2.fq.gz
mv HmA010404D_CKDL220009543-1a-AK9143-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_040-Ex1-04D_L3_1.fq.gz
mv HmA010404D_CKDL220009543-1a-AK9143-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_040-Ex1-04D_L3_2.fq.gz
mv HmA010414F_CKDL220009543-1a-AK9143-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_041-Ex1-04F_L3_1.fq.gz
mv HmA010414F_CKDL220009543-1a-AK9143-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_041-Ex1-04F_L3_2.fq.gz
mv HmA010415D_CKDL220009543-1a-5UDI225-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_041-Ex1-05D_L3_1.fq.gz
mv HmA010415D_CKDL220009543-1a-5UDI225-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_041-Ex1-05D_L3_2.fq.gz
mv HmA010425F_CKDL220009543-1a-5UDI225-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_042-Ex1-05F_L3_1.fq.gz
mv HmA010425F_CKDL220009543-1a-5UDI225-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_042-Ex1-05F_L3_2.fq.gz
mv HmA010426D_CKDL220009543-1a-AK9144-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_042-Ex1-06D_L3_1.fq.gz
mv HmA010426D_CKDL220009543-1a-AK9144-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_042-Ex1-06D_L3_2.fq.gz
mv HmA010436F_CKDL220009543-1a-AK9144-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_043-Ex1-06F_L3_1.fq.gz
mv HmA010436F_CKDL220009543-1a-AK9144-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_043-Ex1-06F_L3_2.fq.gz
mv HmA010437D_CKDL220009543-1a-AK3911-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_043-Ex1-07D_L3_1.fq.gz
mv HmA010437D_CKDL220009543-1a-AK3911-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_043-Ex1-07D_L3_2.fq.gz
mv HmA010447F_CKDL220009543-1a-AK3911-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_044-Ex1-07F_L3_1.fq.gz
mv HmA010447F_CKDL220009543-1a-AK3911-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_044-Ex1-07F_L3_2.fq.gz
mv HmA010448D_CKDL220009543-1a-5UDI245-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_044-Ex1-08D_L3_1.fq.gz
mv HmA010448D_CKDL220009543-1a-5UDI245-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_044-Ex1-08D_L3_2.fq.gz
mv HmA010458F_CKDL220009543-1a-5UDI245-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_045-Ex1-08F_L3_1.fq.gz
mv HmA010458F_CKDL220009543-1a-5UDI245-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_045-Ex1-08F_L3_2.fq.gz
mv HmA010459D_CKDL220009543-1a-AK8593-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_045-Ex1-09D_L3_1.fq.gz
mv HmA010459D_CKDL220009543-1a-AK8593-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_045-Ex1-09D_L3_2.fq.gz
mv HmA0104610D_CKDL220009543-1a-5UDI294-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_046-Ex1-10D_L3_1.fq.gz
mv HmA0104610D_CKDL220009543-1a-5UDI294-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_046-Ex1-10D_L3_2.fq.gz
mv HmA010469F_CKDL220009543-1a-AK8593-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_046-Ex1-09F_L3_1.fq.gz
mv HmA010469F_CKDL220009543-1a-AK8593-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_046-Ex1-09F_L3_2.fq.gz
mv HmA0104710F_CKDL220009543-1a-5UDI294-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_047-Ex1-10F_L3_1.fq.gz
mv HmA0104710F_CKDL220009543-1a-5UDI294-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_047-Ex1-10F_L3_2.fq.gz
mv HmA0104711D_CKDL220009543-1a-AK9146-AK7558_HN325DSX3_L3_1.fq.gz Hmi-ABas_047-Ex1-11D_L3_1.fq.gz
mv HmA0104711D_CKDL220009543-1a-AK9146-AK7558_HN325DSX3_L3_2.fq.gz Hmi-ABas_047-Ex1-11D_L3_2.fq.gz
mv HmA0104811F_CKDL220009543-1a-AK9146-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_048-Ex1-11F_L3_1.fq.gz
mv HmA0104811F_CKDL220009543-1a-AK9146-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_048-Ex1-11F_L3_2.fq.gz
mv HmA0104912F_CKDL220009543-1a-AK5577-AK2587_HN325DSX3_L3_1.fq.gz Hmi-AMac_049-Ex1-12F_L3_1.fq.gz
mv HmA0104912F_CKDL220009543-1a-AK5577-AK2587_HN325DSX3_L3_2.fq.gz Hmi-AMac_049-Ex1-12F_L3_2.fq.gz
mv HmC010011A_CKDL220009543-1a-AK9141-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_001-Ex1-01A_L3_1.fq.gz
mv HmC010011A_CKDL220009543-1a-AK9141-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CBas_001-Ex1-01A_L3_2.fq.gz
mv HmC010011D_CKDL220009543-1a-AK9141-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_001-Ex1-01D_L3_1.fq.gz
mv HmC010011D_CKDL220009543-1a-AK9141-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_001-Ex1-01D_L3_2.fq.gz
mv HmC010022A_CKDL220009543-1a-AK3905-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CPar_002-Ex1-02A_L3_1.fq.gz
mv HmC010022A_CKDL220009543-1a-AK3905-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CPar_002-Ex1-02A_L3_2.fq.gz
mv HmC010029C_CKDL220009543-1a-AK6881-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_002-Ex1-09C_L3_1.fq.gz
mv HmC010029C_CKDL220009543-1a-AK6881-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_002-Ex1-09C_L3_2.fq.gz
mv HmC010032E_CKDL220009543-1a-AK3905-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_003-Ex1-02E_L3_1.fq.gz
mv HmC010032E_CKDL220009543-1a-AK3905-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_003-Ex1-02E_L3_2.fq.gz
mv HmC010039F_CKDL220009543-1a-AK6881-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CBas_003-Ex1-09F_L3_1.fq.gz
mv HmC010039F_CKDL220009543-1a-AK6881-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CBas_003-Ex1-09F_L3_2.fq.gz
mv HmC0100410B_CKDL220009543-1a-AK6260-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CBas_004-Ex1-10B_L3_1.fq.gz
mv HmC0100410B_CKDL220009543-1a-AK6260-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CBas_004-Ex1-10B_L3_2.fq.gz
mv HmC0100410D_CKDL220009543-1a-AK6260-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_004-Ex1-10D_L3_1.fq.gz
mv HmC0100410D_CKDL220009543-1a-AK6260-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_004-Ex1-10D_L3_2.fq.gz
mv HmC0100510G_CKDL220009543-1a-AK6260-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_005-Ex1-10G_L3_1.fq.gz
mv HmC0100510G_CKDL220009543-1a-AK6260-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_005-Ex1-10G_L3_2.fq.gz
mv HmC010053E_CKDL220009543-1a-AK7761-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_005-Ex1-03E_L3_1.fq.gz
mv HmC010053E_CKDL220009543-1a-AK7761-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_005-Ex1-03E_L3_2.fq.gz
mv HmC010063H_CKDL220009543-1a-AK7761-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_006-Ex1-03H_L3_1.fq.gz
mv HmC010063H_CKDL220009543-1a-AK7761-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_006-Ex1-03H_L3_2.fq.gz
mv HmC010064C_CKDL220009543-1a-5UDI298-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CPar_006-Ex1-04C_L3_1.fq.gz
mv HmC010064C_CKDL220009543-1a-5UDI298-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CPar_006-Ex1-04C_L3_2.fq.gz
mv HmC0100711D_CKDL220009543-1a-AK7010-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_007-Ex1-11D_L3_1.fq.gz
mv HmC0100711D_CKDL220009543-1a-AK7010-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_007-Ex1-11D_L3_2.fq.gz
mv HmC010074F_CKDL220009543-1a-5UDI298-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CBas_007-Ex1-04F_L3_1.fq.gz
mv HmC010074F_CKDL220009543-1a-5UDI298-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CBas_007-Ex1-04F_L3_2.fq.gz
mv HmC0100811H_CKDL220009543-1a-AK7010-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CPar_008-Ex1-11H_L3_1.fq.gz
mv HmC0100811H_CKDL220009543-1a-AK7010-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CPar_008-Ex1-11H_L3_2.fq.gz
mv HmC010085C_CKDL220009543-1a-AK9142-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_008-Ex1-05C_L3_1.fq.gz
mv HmC010085C_CKDL220009543-1a-AK9142-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_008-Ex1-05C_L3_2.fq.gz
mv HmC010095G_CKDL220009543-1a-AK9142-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_009-Ex1-05G_L3_1.fq.gz
mv HmC010095G_CKDL220009543-1a-AK9142-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_009-Ex1-05G_L3_2.fq.gz
mv HmC010096B_CKDL220009543-1a-AK8410-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_009-Ex1-06B_L3_1.fq.gz
mv HmC010096B_CKDL220009543-1a-AK8410-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_009-Ex1-06B_L3_2.fq.gz
mv HmC010106E_CKDL220009543-1a-AK8410-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CBas_010-Ex1-06E_L3_1.fq.gz
mv HmC010106E_CKDL220009543-1a-AK8410-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CBas_010-Ex1-06E_L3_2.fq.gz
mv HmC010107A_CKDL220009543-1a-AK8587-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CPar_010-Ex1-07A_L3_1.fq.gz
mv HmC010107A_CKDL220009543-1a-AK8587-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CPar_010-Ex1-07A_L3_2.fq.gz
mv HmC0101112E_CKDL220009543-1a-5UDI312-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CBas_011-Ex1-12E_L3_1.fq.gz
mv HmC0101112E_CKDL220009543-1a-5UDI312-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CBas_011-Ex1-12E_L3_2.fq.gz
mv HmC010117G_CKDL220009543-1a-AK8587-GC12_HN325DSX3_L3_1.fq.gz Hmi-CPar_011-Ex1-07G_L3_1.fq.gz
mv HmC010117G_CKDL220009543-1a-AK8587-GC12_HN325DSX3_L3_2.fq.gz Hmi-CPar_011-Ex1-07G_L3_2.fq.gz
mv HmC0101212G_CKDL220009543-1a-5UDI312-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_012-Ex1-12G_L3_1.fq.gz
mv HmC0101212G_CKDL220009543-1a-5UDI312-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_012-Ex1-12G_L3_2.fq.gz
mv HmC010128E_CKDL220009543-1a-AK7759-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_012-Ex1-08E_L3_1.fq.gz
mv HmC010128E_CKDL220009543-1a-AK7759-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_012-Ex1-08E_L3_2.fq.gz
mv HmC010131B_CKDL220009543-1a-AK9141-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CBas_013-Ex1-01B_L3_1.fq.gz
mv HmC010131B_CKDL220009543-1a-AK9141-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CBas_013-Ex1-01B_L3_2.fq.gz
mv HmC010139B_CKDL220009543-1a-AK6881-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_013-Ex1-09B_L3_1.fq.gz
mv HmC010139B_CKDL220009543-1a-AK6881-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_013-Ex1-09B_L3_2.fq.gz
mv HmC010142B_CKDL220009543-1a-AK3905-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_014-Ex1-02B_L3_1.fq.gz
mv HmC010142B_CKDL220009543-1a-AK3905-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_014-Ex1-02B_L3_2.fq.gz
mv HmC010149D_CKDL220009543-1a-AK6881-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CBas_014-Ex1-09D_L3_1.fq.gz
mv HmC010149D_CKDL220009543-1a-AK6881-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CBas_014-Ex1-09D_L3_2.fq.gz
mv HmC010152F_CKDL220009543-1a-AK3905-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_015-Ex1-02F_L3_1.fq.gz
mv HmC010152F_CKDL220009543-1a-AK3905-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_015-Ex1-02F_L3_2.fq.gz
mv HmC010159G_CKDL220009543-1a-AK6881-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_015-Ex1-09G_L3_1.fq.gz
mv HmC010159G_CKDL220009543-1a-AK6881-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_015-Ex1-09G_L3_2.fq.gz
mv HmC0101610C_CKDL220009543-1a-AK6260-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_016-Ex1-10C_L3_1.fq.gz
mv HmC0101610C_CKDL220009543-1a-AK6260-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_016-Ex1-10C_L3_2.fq.gz
mv HmC0101610E_CKDL220009543-1a-AK6260-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_016-Ex1-10E_L3_1.fq.gz
mv HmC0101610E_CKDL220009543-1a-AK6260-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_016-Ex1-10E_L3_2.fq.gz
mv HmC0101710H_CKDL220009543-1a-AK6260-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_017-Ex1-10H_L3_1.fq.gz
mv HmC0101710H_CKDL220009543-1a-AK6260-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_017-Ex1-10H_L3_2.fq.gz
mv HmC010173F_CKDL220009543-1a-AK7761-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_017-Ex1-03F_L3_1.fq.gz
mv HmC010173F_CKDL220009543-1a-AK7761-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_017-Ex1-03F_L3_2.fq.gz
mv HmC0101811B_CKDL220009543-1a-AK7010-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CBas_018-Ex1-11B_L3_1.fq.gz
mv HmC0101811B_CKDL220009543-1a-AK7010-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CBas_018-Ex1-11B_L3_2.fq.gz
mv HmC010184D_CKDL220009543-1a-5UDI298-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_018-Ex1-04D_L3_1.fq.gz
mv HmC010184D_CKDL220009543-1a-5UDI298-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_018-Ex1-04D_L3_2.fq.gz
mv HmC0101911E_CKDL220009543-1a-AK7010-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_019-Ex1-11E_L3_1.fq.gz
mv HmC0101911E_CKDL220009543-1a-AK7010-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_019-Ex1-11E_L3_2.fq.gz
mv HmC010194G_CKDL220009543-1a-5UDI298-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_019-Ex1-04G_L3_1.fq.gz
mv HmC010194G_CKDL220009543-1a-5UDI298-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_019-Ex1-04G_L3_2.fq.gz
mv HmC0102011G_CKDL220009543-1a-AK7010-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_020-Ex1-11G_L3_1.fq.gz
mv HmC0102011G_CKDL220009543-1a-AK7010-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_020-Ex1-11G_L3_2.fq.gz
mv HmC0102012A_CKDL220009543-1a-5UDI312-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CPar_020-Ex1-12A_L3_1.fq.gz
mv HmC0102012A_CKDL220009543-1a-5UDI312-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CPar_020-Ex1-12A_L3_2.fq.gz
mv HmC0102112C_CKDL220009543-1a-5UDI312-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_021-Ex1-12C_L3_1.fq.gz
mv HmC0102112C_CKDL220009543-1a-5UDI312-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_021-Ex1-12C_L3_2.fq.gz
mv HmC0102112D_CKDL220009543-1a-5UDI312-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_021-Ex1-12D_L3_1.fq.gz
mv HmC0102112D_CKDL220009543-1a-5UDI312-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_021-Ex1-12D_L3_2.fq.gz
mv HmC010226F_CKDL220009543-1a-AK8410-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CBas_022-Ex1-06F_L3_1.fq.gz
mv HmC010226F_CKDL220009543-1a-AK8410-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CBas_022-Ex1-06F_L3_2.fq.gz
mv HmC010227B_CKDL220009543-1a-AK8587-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_022-Ex1-07B_L3_1.fq.gz
mv HmC010227B_CKDL220009543-1a-AK8587-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_022-Ex1-07B_L3_2.fq.gz
mv HmC0102312F_CKDL220009543-1a-5UDI312-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CBas_023-Ex1-12F_L3_1.fq.gz
mv HmC0102312F_CKDL220009543-1a-5UDI312-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CBas_023-Ex1-12F_L3_2.fq.gz
mv HmC010237H_CKDL220009543-1a-AK8587-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CPar_023-Ex1-07H_L3_1.fq.gz
mv HmC010237H_CKDL220009543-1a-AK8587-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CPar_023-Ex1-07H_L3_2.fq.gz
mv HmC0102412H_CKDL220009543-1a-5UDI312-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_024-Ex1-12H_L3_1.fq.gz
mv HmC0102412H_CKDL220009543-1a-5UDI312-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_024-Ex1-12H_L3_2.fq.gz
mv HmC010248F_CKDL220009543-1a-AK7759-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_024-Ex1-08F_L3_1.fq.gz
mv HmC010248F_CKDL220009543-1a-AK7759-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_024-Ex1-08F_L3_2.fq.gz
mv HmC010251C_CKDL220009543-1a-AK9141-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_025-Ex1-01C_L3_1.fq.gz
mv HmC010251C_CKDL220009543-1a-AK9141-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_025-Ex1-01C_L3_2.fq.gz
mv HmC010251E_CKDL220009543-1a-AK9141-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_025-Ex1-01E_L3_1.fq.gz
mv HmC010251E_CKDL220009543-1a-AK9141-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_025-Ex1-01E_L3_2.fq.gz
mv HmC010261G_CKDL220009543-1a-AK9141-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_026-Ex1-01G_L3_1.fq.gz
mv HmC010261G_CKDL220009543-1a-AK9141-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_026-Ex1-01G_L3_2.fq.gz
mv HmC010262C_CKDL220009543-1a-AK3905-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CPar_026-Ex1-02C_L3_1.fq.gz
mv HmC010262C_CKDL220009543-1a-AK3905-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CPar_026-Ex1-02C_L3_2.fq.gz
mv HmC0102710A_CKDL220009543-1a-AK6260-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CPar_027-Ex1-10A_L3_1.fq.gz
mv HmC0102710A_CKDL220009543-1a-AK6260-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CPar_027-Ex1-10A_L3_2.fq.gz
mv HmC010272D_CKDL220009543-1a-AK3905-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CBas_027-Ex1-02D_L3_1.fq.gz
mv HmC010272D_CKDL220009543-1a-AK3905-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CBas_027-Ex1-02D_L3_2.fq.gz
mv HmC010282H_CKDL220009543-1a-AK3905-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_028-Ex1-02H_L3_1.fq.gz
mv HmC010282H_CKDL220009543-1a-AK3905-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_028-Ex1-02H_L3_2.fq.gz
mv HmC010283B_CKDL220009543-1a-AK7761-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_028-Ex1-03B_L3_1.fq.gz
mv HmC010283B_CKDL220009543-1a-AK7761-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_028-Ex1-03B_L3_2.fq.gz
mv HmC010293C_CKDL220009543-1a-AK7761-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_029-Ex1-03C_L3_1.fq.gz
mv HmC010293C_CKDL220009543-1a-AK7761-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_029-Ex1-03C_L3_2.fq.gz
mv HmC010293G_CKDL220009543-1a-AK7761-GC12_HN325DSX3_L3_1.fq.gz Hmi-CPar_029-Ex1-03G_L3_1.fq.gz
mv HmC010293G_CKDL220009543-1a-AK7761-GC12_HN325DSX3_L3_2.fq.gz Hmi-CPar_029-Ex1-03G_L3_2.fq.gz
mv HmC0103011C_CKDL220009543-1a-AK7010-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CPar_030-Ex1-11C_L3_1.fq.gz
mv HmC0103011C_CKDL220009543-1a-AK7010-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CPar_030-Ex1-11C_L3_2.fq.gz
mv HmC010304A_CKDL220009543-1a-5UDI298-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_030-Ex1-04A_L3_1.fq.gz
mv HmC010304A_CKDL220009543-1a-5UDI298-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CBas_030-Ex1-04A_L3_2.fq.gz
mv HmC010314H_CKDL220009543-1a-5UDI298-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_031-Ex1-04H_L3_1.fq.gz
mv HmC010314H_CKDL220009543-1a-5UDI298-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_031-Ex1-04H_L3_2.fq.gz
mv HmC010315B_CKDL220009543-1a-AK9142-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_031-Ex1-05B_L3_1.fq.gz
mv HmC010315B_CKDL220009543-1a-AK9142-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_031-Ex1-05B_L3_2.fq.gz
mv HmC0103212B_CKDL220009543-1a-5UDI312-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_032-Ex1-12B_L3_1.fq.gz
mv HmC0103212B_CKDL220009543-1a-5UDI312-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_032-Ex1-12B_L3_2.fq.gz
mv HmC010325D_CKDL220009543-1a-AK9142-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CBas_032-Ex1-05D_L3_1.fq.gz
mv HmC010325D_CKDL220009543-1a-AK9142-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CBas_032-Ex1-05D_L3_2.fq.gz
mv HmC010335H_CKDL220009543-1a-AK9142-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_033-Ex1-05H_L3_1.fq.gz
mv HmC010335H_CKDL220009543-1a-AK9142-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_033-Ex1-05H_L3_2.fq.gz
mv HmC010336C_CKDL220009543-1a-AK8410-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CPar_033-Ex1-06C_L3_1.fq.gz
mv HmC010336C_CKDL220009543-1a-AK8410-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CPar_033-Ex1-06C_L3_2.fq.gz
mv HmC010346G_CKDL220009543-1a-AK8410-GC12_HN325DSX3_L3_1.fq.gz Hmi-CBas_034-Ex1-06G_L3_1.fq.gz
mv HmC010346G_CKDL220009543-1a-AK8410-GC12_HN325DSX3_L3_2.fq.gz Hmi-CBas_034-Ex1-06G_L3_2.fq.gz
mv HmC010347C_CKDL220009543-1a-AK8587-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CPar_034-Ex1-07C_L3_1.fq.gz
mv HmC010347C_CKDL220009543-1a-AK8587-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CPar_034-Ex1-07C_L3_2.fq.gz
mv HmC010357E_CKDL220009543-1a-AK8587-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CBas_035-Ex1-07E_L3_1.fq.gz
mv HmC010357E_CKDL220009543-1a-AK8587-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CBas_035-Ex1-07E_L3_2.fq.gz
mv HmC010358A_CKDL220009543-1a-AK7759-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CPar_035-Ex1-08A_L3_1.fq.gz
mv HmC010358A_CKDL220009543-1a-AK7759-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CPar_035-Ex1-08A_L3_2.fq.gz
mv HmC010368C_CKDL220009543-1a-AK7759-AK1864_HN325DSX3_L3_1.fq.gz Hmi-CBas_036-Ex1-08C_L3_1.fq.gz
mv HmC010368C_CKDL220009543-1a-AK7759-AK1864_HN325DSX3_L3_2.fq.gz Hmi-CBas_036-Ex1-08C_L3_2.fq.gz
mv HmC010368G_CKDL220009543-1a-AK7759-GC12_HN325DSX3_L3_1.fq.gz Hmi-CPar_036-Ex1-08G_L3_1.fq.gz
mv HmC010368G_CKDL220009543-1a-AK7759-GC12_HN325DSX3_L3_2.fq.gz Hmi-CPar_036-Ex1-08G_L3_2.fq.gz
mv HmC010371F_CKDL220009543-1a-AK9141-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_037-Ex1-01F_L3_1.fq.gz
mv HmC010371F_CKDL220009543-1a-AK9141-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_037-Ex1-01F_L3_2.fq.gz
mv HmC010379A_CKDL220009543-1a-AK6881-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_037-Ex1-09A_L3_1.fq.gz
mv HmC010379A_CKDL220009543-1a-AK6881-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CBas_037-Ex1-09A_L3_2.fq.gz
mv HmC010381H_CKDL220009543-1a-AK9141-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_038-Ex1-01H_L3_1.fq.gz
mv HmC010381H_CKDL220009543-1a-AK9141-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_038-Ex1-01H_L3_2.fq.gz
mv HmC010389E_CKDL220009543-1a-AK6881-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_038-Ex1-09E_L3_1.fq.gz
mv HmC010389E_CKDL220009543-1a-AK6881-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_038-Ex1-09E_L3_2.fq.gz
mv HmC010392G_CKDL220009543-1a-AK3905-GC12_HN325DSX3_L3_1.fq.gz Hmi-CPar_039-Ex1-02G_L3_1.fq.gz
mv HmC010392G_CKDL220009543-1a-AK3905-GC12_HN325DSX3_L3_2.fq.gz Hmi-CPar_039-Ex1-02G_L3_2.fq.gz
mv HmC010399H_CKDL220009543-1a-AK6881-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_039-Ex1-09H_L3_1.fq.gz
mv HmC010399H_CKDL220009543-1a-AK6881-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_039-Ex1-09H_L3_2.fq.gz
mv HmC0104010F_CKDL220009543-1a-AK6260-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_040-Ex1-10F_L3_1.fq.gz
mv HmC0104010F_CKDL220009543-1a-AK6260-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_040-Ex1-10F_L3_2.fq.gz
mv HmC010403A_CKDL220009543-1a-AK7761-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_040-Ex1-03A_L3_1.fq.gz
mv HmC010403A_CKDL220009543-1a-AK7761-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CBas_040-Ex1-03A_L3_2.fq.gz
mv HmC0104111A_CKDL220009543-1a-AK7010-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CPar_041-Ex1-11A_L3_1.fq.gz
mv HmC0104111A_CKDL220009543-1a-AK7010-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CPar_041-Ex1-11A_L3_2.fq.gz
mv HmC010413D_CKDL220009543-1a-AK7761-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CBas_041-Ex1-03D_L3_1.fq.gz
mv HmC010413D_CKDL220009543-1a-AK7761-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CBas_041-Ex1-03D_L3_2.fq.gz
mv HmC010424E_CKDL220009543-1a-5UDI298-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CPar_042-Ex1-04E_L3_1.fq.gz
mv HmC010424E_CKDL220009543-1a-5UDI298-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CPar_042-Ex1-04E_L3_2.fq.gz
mv HmC0104311F_CKDL220009543-1a-AK7010-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_043-Ex1-11F_L3_1.fq.gz
mv HmC0104311F_CKDL220009543-1a-AK7010-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_043-Ex1-11F_L3_2.fq.gz
mv HmC010435A_CKDL220009543-1a-AK9142-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_043-Ex1-05A_L3_1.fq.gz
mv HmC010435A_CKDL220009543-1a-AK9142-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CBas_043-Ex1-05A_L3_2.fq.gz
mv HmC010445E_CKDL220009543-1a-AK9142-7UDI308_HN325DSX3_L3_1.fq.gz Hmi-CBas_044-Ex1-05E_L3_1.fq.gz
mv HmC010445E_CKDL220009543-1a-AK9142-7UDI308_HN325DSX3_L3_2.fq.gz Hmi-CBas_044-Ex1-05E_L3_2.fq.gz
mv HmC010445F_CKDL220009543-1a-AK9142-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CPar_044-Ex1-05F_L3_1.fq.gz
mv HmC010445F_CKDL220009543-1a-AK9142-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CPar_044-Ex1-05F_L3_2.fq.gz
mv HmC010456A_CKDL220009543-1a-AK8410-7UDI214_HN325DSX3_L3_1.fq.gz Hmi-CBas_045-Ex1-06A_L3_1.fq.gz
mv HmC010456A_CKDL220009543-1a-AK8410-7UDI214_HN325DSX3_L3_2.fq.gz Hmi-CBas_045-Ex1-06A_L3_2.fq.gz
mv HmC010456D_CKDL220009543-1a-AK8410-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_045-Ex1-06D_L3_1.fq.gz
mv HmC010456D_CKDL220009543-1a-AK8410-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_045-Ex1-06D_L3_2.fq.gz
mv HmC010466H_CKDL220009543-1a-AK8410-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CBas_046-Ex1-06H_L3_1.fq.gz
mv HmC010466H_CKDL220009543-1a-AK8410-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CBas_046-Ex1-06H_L3_2.fq.gz
mv HmC010467D_CKDL220009543-1a-AK8587-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CPar_046-Ex1-07D_L3_1.fq.gz
mv HmC010467D_CKDL220009543-1a-AK8587-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CPar_046-Ex1-07D_L3_2.fq.gz
mv HmC010477F_CKDL220009543-1a-AK8587-AK2587_HN325DSX3_L3_1.fq.gz Hmi-CBas_047-Ex1-07F_L3_1.fq.gz
mv HmC010477F_CKDL220009543-1a-AK8587-AK2587_HN325DSX3_L3_2.fq.gz Hmi-CBas_047-Ex1-07F_L3_2.fq.gz
mv HmC010478B_CKDL220009543-1a-AK7759-AK4971_HN325DSX3_L3_1.fq.gz Hmi-CPar_047-Ex1-08B_L3_1.fq.gz
mv HmC010478B_CKDL220009543-1a-AK7759-AK4971_HN325DSX3_L3_2.fq.gz Hmi-CPar_047-Ex1-08B_L3_2.fq.gz
mv HmC010488D_CKDL220009543-1a-AK7759-AK7558_HN325DSX3_L3_1.fq.gz Hmi-CBas_048-Ex1-08D_L3_1.fq.gz
mv HmC010488D_CKDL220009543-1a-AK7759-AK7558_HN325DSX3_L3_2.fq.gz Hmi-CBas_048-Ex1-08D_L3_2.fq.gz
mv HmC010488H_CKDL220009543-1a-AK7759-7UDI246_HN325DSX3_L3_1.fq.gz Hmi-CPar_048-Ex1-08H_L3_1.fq.gz
mv HmC010488H_CKDL220009543-1a-AK7759-7UDI246_HN325DSX3_L3_2.fq.gz Hmi-CPar_048-Ex1-08H_L3_2.fq.gz
```

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture
../../../scripts/Renameinator.sh
ls
```

I verified the file names were changed.

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "files renamed"
```

### Quality Check

I checked the quality of the data by running the script [Multi_FASTQC.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/Multi_FASTQC.sh).  The instructions are unclear here.  The instructions lean on referencing shotgun_raw_fq making this part confusing.  I would remove direct references to shotgun_raw_fq and present it stricly as an option such as:

```sh
cd YOUR_SPECIES_DIR/YOUR_LIBRARY_DIR
#for ssl YOUR_LIBRARY_DIR is shotgun_raw_fq
#for cssl YOUR_LIBRARY_DIR is raw_fq_capture

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/
mkdir shotgun_raw_fq
cd shotgun_raw_fq
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture" "fq.gz"
squeue -u ilope002
```

The job produced an outfile:

```sh
Fcntl.c: loadable library and perl binaries are mismatched (got handshake key 0xcd00080, needed 0xde00080)
[WARNING]         multiqc : MultiQC Version v1.12 now available!
[INFO   ]         multiqc : This is MultiQC v1.9
[INFO   ]         multiqc : Template    : default
[INFO   ]         multiqc : Searching   : /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture
[WARNING]         multiqc : No analysis results found. Cleaning up..
[INFO   ]         multiqc : MultiQC complete
```

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "Multi_FASTQC.sh failed"
```

The script failed because I became confused by the instructions.  In a cssl pipeline I do not need the shotgun_raw_fq dir.  It seemed to me that output must go there, thus the authors emphasis on this dir.  In steps like these, even if it took a little more typing, cutting and pasting, I would segregate cssl and ssl portions of the pipeline.

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing/halichoeres_miniatus
rmdir shotgun_raw_fq
cd raw_fq_capture
salloc
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/ilope002/pire_cssl_data_processing/halichoeres_miniatus/raw_fq_capture" "fq.gz"
squeue -u ilope002
```

The script ran as job #810731.

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "running Multi_FASTQC.sh"
