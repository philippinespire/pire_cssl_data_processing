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

MultiQC complete!
