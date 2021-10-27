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

The initial MultiQC report with all the files [multiqc_report_fq.gz.html](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/Multi_FASTQC/multiqc_report_fq.gz.html) collapsed file statistic into a single plot
 so I re-run MultiQC for Albatross [multiqc_report_Alb.html](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/Multi_FASTQC/Alb_fastqc/multiqc_report_Alb.html) 
and Contemporary files [multiqc_report_Contem.html](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/Multi_FASTQC/Con_fastqc/multiqc_report_Contem.html) separately to be able to see stats file per file.


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

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

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

