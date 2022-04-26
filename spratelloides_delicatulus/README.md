# Sde Data Processing Log

Working dir `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus`

---

**Checking quality of reads**

Running FASTQC
```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/raw_fq_capture/"
```

For some reason FASTQC was getting stuck. I modified the script to run only missing files.

Looks like FASTQC could not process `SdC02092_CKDL210020579-1a-AK7010-7UDI246_HKGLMDSX2_L2_1.fq.gz` this time around. The script kept geting stuck at this file. The previous runs might had getting stuck at other files. Before noticing this, I was not keeping all the failed out files. Check the output for inconsistencies. 

Ended up running FASTQC directly on current session (not with sbatch), and that ran fine.

The initial MultiQC report with all the files [multiqc_report_fq.gz.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/spratelloides_delicatulus/Multi_FASTQC/multiqc_report_fq.gz.html?token=GHSAT0AAAAAABQH4M6JUOA4BQ3UK53FJJDWYSZ3HPA)
 so I re-run MultiQC for Albatross [multiqc_report_Alb.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/spratelloides_delicatulus/Multi_FASTQC/Alb_fastqc/multiqc_report_Alb.html?token=GHSAT0AAAAAABQH4M6IJULKVCIVINXRU4QKYSZ3IEA)
 and Contemporary files [multiqc_report_Contem.html](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/spratelloides_delicatulus/Multi_FASTQC/Con_fastqc/multiqc_report_Contem.html?token=GHSAT0AAAAAABQH4M6J5LMG25ISNAX23FBUYSZ3FQQ)


Download or copy and paste reports for viewing.

SdA01 files are from Sde-AMat		Match ID:  MatB

SdA02 files are from Sde-AMar           Match ID:  PMar

SdC01 files are from Sde-CMat           Match ID:  MatB 

SdC02 files are from Sde-CHam           Match ID:  PMar

**Highlights:**

Sde-AMat Duplication 70-80%s, GC most 40%s few 50%s, Num of Reads 2-38 M (most in the 10-20s M)

Sde-AMar Duplication 70-80%s(only one file ~60%), GC 50-60%s, Num of Reads 2-12 M (most <10 M)

Sde-CMat Duplication 70-80%s, GC mostly 40%s, Num of Reads 1.3-37 M (most in the 10-20s M)

Sde-CHam Duplication 50-80%s(few 40%s), GC mostly 40%s, Num of Reads <1-10 M (great majority <1 M)


**Noticible dicotomy of sequence results across the 2 locations**

Major differences do not correlate with era but with location:

Matnog Bay (Southern Luzon); MatB=SdA01:Sde-AMat,  SdC01:Sde-CMat; normal GC content and good amounts of reads

Port Maricaban (Northern Luzon); PMar=SdA02:Sde-AMar, SdC02:Sde-CHam; higer GC content and subtantially less sequences than MatB


Potential reasons could be library effects (need to check how populations were prepare) or lot effects. Also need to check extraction records.


---

## Step 1.  1st fastp

Running the first trim (3'):
```
cd /home/e1garica/pire_cssl_data_processing/spratelloides_delicatulus
#runFASTP_1.sbatch <indir> <outdir>
# do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch "raw_fq_capture" "./fq_fp1"
```

**Results below are not for  Sde. STILL HAVENT ASSESS THIS**

[Report](https://htmlpreview.github.io/?https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

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

bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmparray /scratch/e1garcia 58

mv spratelloides_delicatulus/*out spratelloides_delicatulus/logs/

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmparray fq_fp1_clmparray_fp2

## FASTQ SCREEN

Running files that were dropped
```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01007_CKDL210020579-1a-5UDI301-AK10343_HKGLMDSX2_L2_clmp.fp2_r2.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01016_CKDL210020579-1a-AK7758-AK4234_HKGLMDSX2_L2_clmp.fp2_r1.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01017_CKDL210020579-1a-AK7758-GD06_HKGLMDSX2_L2_clmp.fp2_r2.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01018_CKDL210020579-1a-AK7078-AK533_HKGLMDSX2_L2_clmp.fp2_r2.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01026_CKDL210020579-1a-AK9143-AK533_HKGLMDSX2_L2_clmp.fp2_r1.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01027_CKDL210020579-1a-AK9143-AK7557_HKGLMDSX2_L2_clmp.fp2_r1.fq.gz
```

MultiQC on screend files
```
sbatch ../scripts/runMULTIQC.sbatch fq_fp1_clmparray_fp2_fqscrn multiqc_fqscrn_Sde_capture
```

Link to view report:
[multiqc_fscrn_Sde_capture_report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/spratelloides_delicatulus/fq_fp1_clmparray_fp2_fqscrn/1st_multiqc_fqscrn_Sde_capture.html?token=GHSAT0AAAAAABQH4M6IECPNRYGKYBDK3WUEYTIBMSA)

If the above link doesn't load succesfully download the report [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/fq_fp1_clmparray_fp2_fqscrn/1st_multiqc_fqscrn_Sde_capture.html) and open locally. 

## Repaired
```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmparray_fp2_fqscrn fq_fp1_clmparray_fp2_fqscrn_repaired 40
```
