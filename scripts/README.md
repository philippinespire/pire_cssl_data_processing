# Generic Data Processing Log

copy and paste this into a new species dir and fill in as steps are accomplished.

---

## Step 1.  1st fastp

Locate data location in slack channel for this species to get the indir.  The outdir should be `/home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR`

```
# repalce YOURUSERNAME and SPECIESDIR in paths
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR

#runFASTP_1.sbatch <indir> <outdir>
sbatch ../scripts/runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/SPECIESDIR/fq_raw fq_fp1
```

[Report](fill in url to multiqc report here), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

Potential issues:  
* fill in

---

## Step 2. Clumpify

Clumpify can use a lot of ram and if it runs out you will loose files.  [checkClumpify.R]() should be run after clumpify to make sure no files ran out of ram.  You can also use `sacct` to query how much ram was used to dial this in.

There are two ways to run, either as a normal sbatch script on a turing himem node `runCLUMPIFY.sbatch` or as an array on multiple nodes simultaneously.

```
# run clumpify as normal sbatch on turing
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
sbatch ../scripts/runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/YOURUSERNAME
#when complete, search the *out file for java.lang.OutOfMemoryError.  If this occurs, then increase ram, set groups to 1 in script
```

```
cd /home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR
#runCLUMPIFY_r1r2_array.bash <indir> <outdir> <tempdir>
bash ../scripts/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmparray /scratch/YOURUSERNAME 20
#after completion, run checkClumpify.R to see if any files failed
```

---

## Step 3. Run fastp2

I updated the variables

```
sbatch runFASTP_2nd_trim.sbatch
```

[Report](https://github.com/tamucc-gcl/prj_garcia_nudibranchs/blob/main/h_emurai/fq_fp1_clmp_fp2/2nd_fastp_report.html), download and open in web browser

Potential issues:
* about 50% of reads were tossed due to our MINLEN=140.  We probably want to make this less stringent when trimming files for mapping.

had to rename files
```
cd fq_fp1_clmp_fpw
rename clmp_fp2_r clmp-fp2-r *gz
cd ..
```

---

## Step 4. Run fastq_screen

I made the config file by filling in the `runFQSCRN_5.xlsx` work sheet and copying column K into `runFQSCRN_5.config`, not including row 1.

```
# arguments are name of config file and number of nodes to run jobs on
bash runFQSCRN_5.bash runFQSCRN_5.config 5
```

[Report](https://github.com/tamucc-gcl/prj_garcia_nudibranchs/blob/main/h_emurai/fq_fp1_clmp_fp2_fqscrn/multiqc_report.html), download and open in web browser

Potential issues:
CPIC_01882 has low number of reads.  To salvage for mapping, will have to run fp2 and fqscrn again with more permissive length settings. Will use these for making ref genome

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

