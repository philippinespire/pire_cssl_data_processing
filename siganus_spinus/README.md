## Siganus spinus CSSL data processing

### 1. Rename files

Trying the re-vamped (as of 9/29/22) rename script. So far, seems to be working as intended!

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZc.bash Ssp_CaptureLibraries_SequenceNameDecode.tsv
```

Other directory setup:
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/
mkdir logs
```

Copying raw (renamed) seqs to RC since they are not there yet!

```
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus
cp -r raw_fq_capture /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus
```

### 2. fq.gz processing

Attempting to run MultiQC.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "fq.gz"
```

MultiQC is stalling at one specific file for some reason. Trying to run it now on A files first, then C files

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-A*fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-C*fq.gz"
```

Still stalls - does not work for: 
Ssp-AAtu_021, Ssp-AAtu_043, Ssp-AAtu_046
Ssp-CGub_004, Ssp-CGub_011, Ssp-CGub_040, Ssp-CGub_049, Ssp-CGub_056, Ssp-CGub_059, Ssp-CGub_091

For some reason these are all of the files with sizes in the range 7-25 Mb. All files smaller or larger worked. No indication that anything is particularly weird - .1 and .2 files are same # of lines (so probably nothing went wrong in file transfer) and look like regular fq.gz files.

Re-trying Albatross failures with modified SingleQC script. These are stalling too.
```
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.1.fq.gz"
```

Re-trying failures with SingleQC script - no parallel. It works!!
```
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_004-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_004-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_011-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_011-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_040-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_040-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_049-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_049-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_056-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_056-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_059-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_059-Ex1-cssl.2.fq.gz"

sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_091-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-CGub_091-Ex1-cssl.2.fq.gz"
```

Run MultiQC.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" fastqc_report
```

MultiQC [report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/raw_fq_capture/fastqc_report.html) summary:
* Highly variable # of sequences. 100k - 104.8M. Most Albatross between 500k-1M.
* Quality looks OK.
* GC content warnings for some Albatross samples - bimodal distribution of GC content (target + contamination? Maybe this will be fixed in fqscreen) 
* Low N content, good sequence lengths
* High duplication for Albatross + some contemps (to be expected for capture?)
* High adapter content, some overrepresented sequence warnings.

### 3. First trim.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/

#sbatch runFASTP_1st_trim.sbatch <indir> <outdir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch raw_fq_capture fq_fp1
```

MultiQC [report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/fq_fp1/1st_fastp_report.html) summary:
* Most reads for Albatross + contemporary pass filter
* High duplication + % adapter still for a lot of Albatross.
* GC content variable for Albatross
* Lower insert size on average for Albatross

### 4. Clumpify / remove duplicates

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/

#runCLUMPIFY_r1r2_array.bash <indir; fast1 files> <outdir> <tempdir> <max # of nodes to use at once>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/breid 20
```

Check clumpify.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2

cp /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R .

crun R < checkClumpify_EG.R --no-save
exit #to relinquish the interactive node
```

Clumpify Successfully worked on all samples!

### 5. Second fastp trim.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```
