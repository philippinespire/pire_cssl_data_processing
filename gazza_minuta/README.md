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
* % duplication - good
  * Alb: ~10%, Contemp: ~10%
* GC content - good
*  Alb: 40%, Contemp: 45%
* passing filter - good
  * Alb: ~98%, Contemp: ~99%
* % adapter - good
  * Alb: <2%, Contemp: <1%
* number of reads - took a hit, especially Albatross
  * Alb: about half ~10-25 mil & about half ~1-7 mil, Contemp: 5-10 mil
