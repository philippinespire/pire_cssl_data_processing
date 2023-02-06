The Tbi-A resequencing cssl data are back and can be found on the TAMUCC HPC at /work/hobi/webshare/20230123_PIRE-Tbi-A-capture2 or at https://gridftp.tamucc.edu/genomics/20230123_PIRE-Tbi-A-capture2/ The sequence name decode sheet is in with the data.
Note there is an updated naming scheme that is formatted as Extraction_id-LibraryPlateWell-LibraryType-Library_id-SeqRun. Extraction_ID is the sample name and extraction from the Extraction database, LibraryPlateWell is the well that the library was processed in. LibraryType is ssl, cssl, or lcwgs. Library_id refers to which library was used (sometimes there were multiple libraries made for an individual). SeqRun is the number of times that individual has been sequenced for this library type.

## 2nd sequencing run

### 0. Rename and back up

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/raw_fq_capture
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Tbi-A_cssl2_SequenceNameDecode.txt
```

Looks OK - proceeding to rename:

```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Tbi-A_cssl2_SequenceNameDecode.txt rename
```

Back up renamed files. I moved these to siganus first by mistake

```
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run
cp -r fq_raw /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/2nd_sequencing_run
mv /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/2nd_sequencing_run
```

### 1. MultiQC

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/2nd_sequencing_run/fq_raw" "fq.gz"
```

Summary [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/taeniamia_biguttata/2nd_sequencing_run/fq_raw/fq.gz.html):
* ≥ 1M reads per library; most >2M, a few >10M
* High duplication (50-90%)
* Good quality
* GC content a bit all over the place - some contamination?
* High adapter content


### 2. First trim.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/2nd_sequencing_run

#sbatch runFASTP_1st_trim.sbatch <indir> <outdir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
```

Summary [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/taeniamia_biguttata/2nd_sequencing_run/fq_fp1/1st_fastp_report.html):
* Duplication + adapter content still high
* Still high variation in GC content 
* Most reads (>90%) passed filter however

### 3. Clumpify

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/2nd_sequencing_run

#runCLUMPIFY_r1r2_array.bash <indir; fast1 files> <outdir> <tempdir> <max # of nodes to use at once>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/breid 20
```

Check clumpify.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata/2nd_sequencing_run

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2

cp /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R .

crun R < checkClumpify_EG.R --no-save
exit #to relinquish the interactive node
```
