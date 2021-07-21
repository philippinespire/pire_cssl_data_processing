# Generic Data Processing Log

copy and paste this into a new species dir and fill in as steps are accomplished.

---

## Step 1.  1st fastp

Locate data location in slack channel for this species to get the indir.  The outdir should be `/home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR`

```
# repalce YOURUSERNAME and SPECIESDIR in paths
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR

#runFASTP_1.sbatch <indir> <outdir>
# do not use trailing / in paths
sbatch ../scripts/runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/SPECIESDIR/fq_raw fq_fp1
```

[Report](fill in url to multiqc report here), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

Potential issues:  
* % duplication - ____  
  * alb:__s, contemp: __s
* gc content - ______
  * alb: __s, contemp: __s 
* passing filter - ____
  * alb: __s, contemp: __s 
* % adapter - ______
  * alb: __s, contemp: __s
* number of reads - ________
    * alb: __ mil, contemp: __ mil

---

## Step 2. Clumpify

Clumpify can use a lot of ram and if it runs out you will loose files.  [checkClumpify.R]() should be run after clumpify to make sure no files ran out of ram.  You can also use `sacct` to query how much ram was used to dial this in.

There are two ways to run, either as a normal sbatch script on a turing himem node:
```
# run clumpify as normal sbatch on turing
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
# do not use trailing / in paths
sbatch ../scripts/runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/YOURUSERNAME
#when complete, search the *out file for `java.lang.OutOfMemoryError`.  If this occurs, then increase ram, set groups to 1 in script
```

or as an array on multiple wahab nodes simultaneously:

```
#note: this runs out of ram right now.  not sure why
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR
#runCLUMPIFY_r1r2_array.bash <indir> <outdir> <tempdir>
# do not use trailing / in paths
bash ../scripts/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmparray /scratch/YOURUSERNAME 20
#after completion, run checkClumpify.R to see if any files failed
```

Cleanup logs
```
mkdir logs
mv *out logs
```

---

## Step 3. Run fastp2

Insert notes here

```
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR
#runFASTP_2.sbatch <indir> <outdir> 
# do not use trailing / in paths
sbatch ../scripts/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](insert url to report here), download and open in web browser

Potential issues:  
* % duplication - ____  
  * alb:__s, contemp: __s
* gc content - ______
  * alb: __s, contemp: __s 
* passing filter - ____
  * alb: __s, contemp: __s 
* % adapter - ______
  * alb: __s, contemp: __s
* number of reads - ________
    * alb: __ mil, contemp: __ mil

---

## Step 4. Run fastq_screen

Insert notes here

```
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR
#runFASTP_2.sbatch <indir> <outdir> 
# do not use trailing / in paths
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20

#confirm that all files were successfully completed
# this will return any out files that had a problem, replace JOBID with your jobid
grep 'error' slurm-fqscrn.JOBID*out
# if you see missing indiviudals or categories in the multiqc output, there was likely a ram error.  I'm not sure if the "error" search term catches it.
```

[Report](), download and open in web browser

Potential issues:


Cleanup logs
```
mkdir logs
mv *out logs
```

---

## Step 5. repair fastq_screen paired end files

Edited script and ran.  Make output files have `r1` and `r2` rather than `R1` and `R2` for compatibility with dDocent `mkREF`

```
sbatch runREPAIR.sbatch
rename .R1. .r1. fq_fp1_clmp_fp2_fqscrn_repaired/*gz
rename .R2. .r2. fq_fp1_clmp_fp2_fqscrn_repaired/*gz
```

---

## Step 6. Repair fastq_screen paired end files for mapping

waiting for step 8 to finish

---

## Step 7.  Get reference genome


---

### Step 8. Map reads to reference

fill in

```
fill in commands
```

