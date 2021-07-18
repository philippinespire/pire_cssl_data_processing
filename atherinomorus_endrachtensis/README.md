# Aen Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Atherinomorus endrachtensis* samples from Hamilo Cove.

---

## Step 1.  1st fastp

Raw data in `/home/e1garcia/shotgun_PIRE/Aen/raw_fq` (check Atherinomorus-endrachtensis channel on Slack).  The root outdir for all analyses will be  `/home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus-endrachtensis`. Both on Wahab/Turing (ODU HPCs).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFASTP_1.sbatch <indir> <outdir>
sbatch runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Aen/raw_fq fq_fp1
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - high for most but not all Albatross, lower for contemporary
  * Alb: ~60% (some in the 40s), Contemp: ~45%
* GC content - good
* passing filter - most reads passed filters for both Albatross & contemporary
  * Alb: >90% (some closer to 50-60% and those tend to be ones with lower % dup), Contemp: ~95% passed for contemp
* % adapter - high, esp. for Albatross
  * Alb: 80%, Contemp: 30-40%
* number of reads - seems to be okay
  * Alb: generally much higher # (>40 mil) BUT some are very low (1-2 mil), Contemp: ~10-20 mil

---

## Step 2. Clumpify

```
#on Turing
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

enable_lmod
sbatch runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/r3clark
```

---

## Step 3. Run fastp2

```
scd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

sbatch runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
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
