# Lle Data Processing Log

copy and paste this into a new species dir and fill in as steps are accomplished.

---

## Step 1.  1st fastp

Locate data location in slack channel for this species to get the indir.  The outdir should be `/home/yourusername/pire_cssl_data_processing/yourspeciesdir`

```
#runFASTP_1.sbatch <indir> <outdir>
sbatch runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Lle/fq_raw /home/e1garcia/shotgun_PIRE/fq_fp1
```

[Report](fill in url), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

Potential issues:  
* fill in

---

## Step 2. Clumpify

```
fill in
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

