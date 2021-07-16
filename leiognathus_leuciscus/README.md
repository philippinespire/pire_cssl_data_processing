# Lle Data Processing Log

copy and paste this into a new species dir and fill in as steps are accomplished.

---

## Step 1.  1st fastp

Locate data location in slack channel for this species to get the indir.  The outdir should be `/home/YOURUSERNAME/pire_cssl_data_processing/SPECIESDIR`

```
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runFASTP_1.sbatch <indir> <outdir>
sbatch ../scripts/runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Lle/fq_raw fq_fp1
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/leiognathus_leuciscus/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

Potential issues:  
* % duplication - high for albatross, 
  * alb:70s, contemp: 50s
* gc content - reasonable
* passing filter - good
* % adapter - high, but that was expected, 
  * alb: 80s, contemp: 40s
* number of reads - decent
  * generally more for albatross than contemp, as we attempted to do
  * alb: 30mil, contemp: 8 mil
 
---

## Step 2. Clumpify

something odd happened here, so I'm running it again.
```
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
sbatch ../scripts/runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/cbird
```

this runs clumpify in an array, but the script is running out of memory

```
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runCLUMPIFY_r1r2_array.bash <indir> <outdir> <tempdir> <num nodes>
bash ../scripts/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmparray /scratch/cbird 20
```
---

## Step 3. Run fastp2

will need to run again with clumpify is done

```
cd /home/cbird/pire_cssl_data_processing/leiognathus_leuciscus
#runFASTP_2.sbatch <indir> <outdir> 
sbatch ../scripts/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/leiognathus_leuciscus/fq_fp1_clmp_fp2/2nd_fastp_report_1.html), download and open in web browser

Potential issues:  
* % duplication - good  
  * alb:20s, contemp: 20s
* gc content - reasonable
  * alb: 40s, contemp: 40s 
* passing filter - good
  * alb: 90s, contemp: 90s 
* % adapter - good
  * alb: 2s, contemp: 2s
* number of reads - lost alot for albatross
  * generally more for albatross than contemp, as we attempted to do
  * alb: 7 mil, contemp: YY mil


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

