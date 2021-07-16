# _H. emurai_ ddRAD Processing

---

## Step 1.  1st fastp

To avoid messing with the name in the orig files, I decided to run fastp first, then change the file names after it completes.

I decided to work inside the repo. It looks like Jason made it so that large fq.gz files won't be included in the github repo.  I added some additional file extensions to that, like .bam 


```
cd h_emurai
cp ../scripts/runFASTP_1st_trim.sbatch runFASTP_1st_trim_4ref.sbatch
#I edited `runFASTP_1st_trim.sbatch` for this species and reference creation.
# set MINLEN=140
sbatch runFASTP_1st_trim_4ref.sbatch
#I had to move unpaired reads to failed dir, will update script so others don't have to
cd fq_fp1
mv *unprd* failed
```

[Report](fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

Potential issues:  
* duplication rate 50% in CPIC-01882
* CPIC-01882 has small amount of reads compared to other samples, but still over 1mil

---

## Step 2. Rename files for dDocent/freebayes compatibility

```
cd fq_fp1
rename CPIC- hem-CPIC_ *fq.gz
cd ..
```

---

## Step 3. Clumpify

```
cp ../scripts/runCLUMPIFY_r1r2.sbatch .
# i edited the script variables
sbatch runCLUMPIFY_r1r2.sbatch

#when done, query the slurm out file
less -S filename
#search terms:  Done!
#look for failed libs, check each 1
```

---

## Step 4. Run fastp2

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

## Step 5. Run fastq_screen

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

## Step 6. repair fastq_screen paired end files

Edited script and ran.  Make output files have `r1` and `r2` rather than `R1` and `R2` for compatibility with dDocent `mkREF`

```
sbatch runREPAIR.sbatch
rename .R1. .r1. fq_fp1_clmp_fp2_fqscrn_repaired/*gz
rename .R2. .r2. fq_fp1_clmp_fp2_fqscrn_repaired/*gz
```

---

## Step 7. Trim fastp2 for mapping

Made copy of script, updated, made MINLEN=75, and ran

```
sbatch runFASTP_2nd_trim_4map.sbatch
```

---

## Step 8. Run fastq_screen for mapping

Edited the config file and ran

```
bash runFQSCRN_5.bash runFQSCRN_5_4map.config 5
sbatch runMULTIQC.sbatch /work/hobi/cbird/prj_garcia_nudibranchs/h_emurai/fq_fp1_clmp_fp2_fqscrn_4map
```

---

## Step 9. Repair fastq_screen paired end files for mapping

waiting for step 8 to finish

---

## Step 10.  Create reference genome

I prepped a dir for making the ref genome

```
pwd
/work/hobi/cbird/prj_garcia_nudibranchs/h_emurai
mkdir mkREF
mv fq_fp1_clmp_fp2_fqscrn_repaired/*gz mkREF
```

Make sure the files follow the dDocent naming convention 
* only 1 underscore, and it delineates group from individiual
* `.r1.fq.gz` `.r2.fq.gz` suffixes requried

I cloned [dDocentHPC](https://github.com/cbirdlab/dDocentHPC) to my local directory, and added it to `.gitignore`.  It is one dir above my current dir.

```
cp ../mkREF/dDocentHPC/dDocentHPC.sbatch .
cp ../mkREF/dDocentHPC/config.5.all .
cp fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz mkREF
cd mkREF
```

I edited the sbatch file to work with my dir structure and only run mkREF.  I used the default settings in the config.

```
sbatch dDocentHPC.sbatch
```

Check the number of contigs
```
[cbird@hpcm01 mkREF]$ grep '^>' reference.2.2.fasta | wc -l
761
```
This produced a ref with only ~700 contigs.  A review of the ref revealed that most contigs were made from completely overlapping reads; therefore the mode of dDocent should be changed in the config from PE to OL.

I prepped a new dir changed the config settings copied files from prev dir and ran again.

```
[cbird@hpcm01 h_emurai]$ pwd
/work/hobi/cbird/prj_garcia_nudibranchs/h_emurai

mkdir mkREF_OL
cp mkREF/*sbatch mkREF_OL
cp mkREF/config* mkREF_OL
mv mkREF/*fq.gz mkREF_OL 
cd mkREF_OL

#make sure config and sbatch files are updated before running
sbatch dDocentHPC.sbatch
```

Check num contigs
```
[cbird@hpcm01 mkREF_OL]$ grep '^>' reference.2.2.fasta | wc -l
3095
```

Over ~3k contigs this time, which is better, but does not bode well for number of contigs surviving alignment across species.

---

### Step 11. Map reads to reference

waiting for previous steps to finish


