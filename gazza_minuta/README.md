# Gmi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Gazza minuta* samples from Hamilo Cove.

---

## Step 1.  1st fastp

Raw data in `/home/e1garcia/shotgun_PIRE/Gmi/raw_fq_capture` (check Gazza minuta channel on Slack).  The root outdir for all analyses will be  `/home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta`. Both on Wahab/Turing (ODU HPCs).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

#runFASTP_1.sbatch <indir> <outdir>
sbatch runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Gmi/raw_fq_capture fq_fp1
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/gazza_minuta/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - low for most Albatross, higher for contemporary
  * Alb: 30-40% (some in the 40s), Contemp: 60-70% (some ~30%)
* GC content - good
  * Alb: 50%, Contemp: 50%
* passing filter - most reads passed filters for both Albatross & contemporary
  * Alb: >90%, Contemp: ~95%
* % adapter - high for Albatross (but not as high as other species), low for contemporary
  * Alb: 55-70%, Contemp: 10%
* number of reads - good for Albatross, okay for contemporary but some libraries seemed to have failed completely
  * Alb: generally much higher # (>40 mil) w/ some very high (~500 mil), Contemp: ~10-20 mil w/some VERY low (only a couple thousand)

---

## Step 2. Clumpify

```
#on Turing
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

enable_lmod
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
sbatch runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/r3clark
```

Checked that all files ran with `checkCLUMPIFY.R`. All ran (no RAM issues).

---

## Step 3. Run fastp2

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

#runFASTP_2.sbatch <indir> <outdir>
sbatch runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/gazza_minuta/fq_fp1_clmp_fp2/2nd_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - Albatross good, contemporary okay
  * Alb: ~5-10%, Contemp: ~30%
* GC content - good
*  Alb: 45%, Contemp: 50%
* passing filter - good
  * Alb: ~99%, Contemp: ~98%
* % adapter - good
  * Alb: <2.5%, Contemp: <1%
* number of reads - went down but Albatross still good, contemporary some are very low
  * Alb: ~5-25 mil with a few >100 mil, Contemp: about half 5-15 mil & about half >1 mil (and likely in the thousands)

---

## Step 4. Run fastq_screen

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously>
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/gazza_minuta/fq_fp1_clmp_fp2_fqscrn/fqscrn_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues: 
* job 13 failed 
  * [out file](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/gazza_minuta/logs/slurm-fqscrn.405009.13.out)
  * "No reads in GmA01013..., skipping"
  * Checked file and there are definitely reads here
* Also, looks like there is more contamination (20-40%) than with other species, esp. in Albatross.

Fixed errors: re-ran file that returned the "No reads in" error.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously> <fq file pattern to process>
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 GmA01013*r1.fq.gz
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 GmA01013*r2.fq.gz
```

Cleaned-up logs.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

mkdir logs
mv *out logs
```

---

## Step 5. Repair fastq_screen paired end files

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```
