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

Did not work for: Ssp-AAtu_021-Ex1-cssl.1.fq.gz, Ssp-AAtu_043-Ex1-cssl.1.fq.gz, Ssp-AAtu_046-Ex1-cssl.1.fq.gz

Re-trying with modified SingleQC script.
```
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_021-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_043-Ex1-cssl.1.fq.gz"
sbatch Single_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "Ssp-AAtu_046-Ex1-cssl.1.fq.gz"
```

