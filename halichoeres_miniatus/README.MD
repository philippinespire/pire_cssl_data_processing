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
#SBATCH --output=/home/ilope002/pire_cssl_data_processing/logs/RenameFQGZbash.out
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
Which according to the decode file would be renamed to Hmi-CBas_001-Ex1-01A_L3_1|2.fq.gz. Two libraries would be overwritten.  I have to confer with my colleages to come up with a proper naming scheme that will not create problems further down the pipeline.  Once we have established a naming scheme I will create a script as follows:

```sh
#!/bin/bash

#SBATCH --exclusive
#SBATCH --mail-user=ilope002@odu.edu
#SBATCH --mail-type=END
#SBATCH --job-name=RenameFQGZ
#SBATCH --output=/home/ilope002/pire_cssl_data_processing/logs/RenameFQGZbash.out
#SBATCH --open-mode=append

echo "SLURM_JOB_ID=$SLURM_JOB_ID"

mv Old_Name_RetainableElement.fq.gz PIRE_NAME_RetainableElement.fq.gz
```

I typed the following commands:

```sh
cd /home/ilope002/pire_cssl_data_processing
../scripts/Gitpushinator.sh "potential file overwrite problem with renaming"
```
