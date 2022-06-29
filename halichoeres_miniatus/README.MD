# Log for Halichoeres Miniatus

The purpose of this log is to create replicable steps for the processing and analysis of capture shotgun data for *H. miniatus* as outlined by Dr. Eric Garcia in the [PIRE CAPTURE SHOTGUN DATA PROCESSING & ANALYSIS Page](https://github.com/philippinespire/pire_cssl_data_processing) of the [PhilippinesPIRE](https://github.com/philippinespire) repository.  All scripts and software used are explained on the PIRE Shotgun repository.  All bioinformatic work was performed on the Old Dominion University (ODU) High Performance Computing Cluster (HPC).  The log and worked performed here was completed by Ivan Lopez, MS, ODU.  I received assitance with scripting from Mr. Min Dong, MS, ODU.

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
git pull origin master
```

The halichores\_miniatus subdir pulled to my dir on HPC /home/ilpoe002/pire_cssl_data_processing/halichoeres_miniatus/

I typed the following commands:

```sh
git add ./*
git commit -m "updated README with Preliminary"
git push -u origin main

***

## fq.gz Preprocessing
