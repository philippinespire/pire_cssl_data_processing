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

Run MultiQC.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/raw_fq_capture" "fq.gz"

```
