The Ssp-A resequencing cssl data are back and can be found at https://gridftp.tamucc.edu/genomics/20230123_PIRE-Ssp-A-capture2/ The sequence name decode sheet is in with the data.
Note there is an updated naming scheme that is formatted as Extraction_id-LibraryPlateWell-LibraryType-Library_id-SeqRun. Extraction_ID is the sample name and extraction from the Extraction database, LibraryPlateWell is the well that the library was processed in. LibraryType is ssl, cssl, or lcwgs. Library_id refers to which library was used (sometimes there were multiple libraries made for an individual). SeqRun is the number of times that individual has been sequenced for this library type.

## 2nd sequencing run

### 0. Rename and back up

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Ssp_CaptureLibraries2_SequenceNameDecode.tsv
```

Looks OK - proceeding to rename:

```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Ssp_CaptureLibraries2_SequenceNameDecode.tsv rename
```

Back up renamed files. I moved these to siganus first by mistake

```
cp -r fq_raw /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run
```

### 1. MultiQC

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "fq.gz"
```

Some did not work and stalled the MULTIQC procedure. Running these with SingleQC and performing MultiQC separately.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_016-Ex1-1F-cssl-2-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_016-Ex1-1F-cssl-2-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_021-Ex1-4C-cssl-2-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_021-Ex1-4C-cssl-2-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_043-Ex1-3G-cssl-2-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_043-Ex1-3G-cssl-2-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_046-Ex1-3C-cssl-2-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" "Ssp-AAtu_046-Ex1-3C-cssl-2-2.2.fq.gz"

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run/fq_raw" fastqc_report
```

Summary [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/2nd_sequencing_run/fq_raw/fastqc_report.html):
* Mostly <1M, though two have ~8M
* Quality good
* GC content all over the place, some look very bad / almost all contamination!
* High duplication (~60-90%) and adapter content.

### 2. First trim.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#sbatch runFASTP_1st_trim.sbatch <indir> <outdir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
```

Summary [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/siganus_spinus/2nd_sequencing_run/fq_fp1/1st_fastp_report.html):
* Still high duplication and adapter content
* Still lots of variation in GC
* > 97% passing filter!

### 3. Clumpify

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#runCLUMPIFY_r1r2_array.bash <indir; fast1 files> <outdir> <tempdir> <max # of nodes to use at once>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/breid 20
```

Check clumpify.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2

cp /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R .

crun R < checkClumpify_EG.R --no-save
exit #to relinquish the interactive node
```

Clumpify Successfully worked on all samples!

Ran `runMULTIQC.sbatch` to get MultiQC output

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#sbatch Multi_FASTQC.sh "<indir>" "<mqc report name>" "<file extension to qc>"
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"
```

### 3. Second trim. Execute runFASTP_2.sbatch

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#sbatch runFASTP_2_cssl.sbatch <indir; clumpified files> <outdir>
#do not use trailing / in paths
sbatch ../../pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```
Potential issues:
  * % duplication -
    * Alb: 17.90%
  * GC content -
    * Alb: 47.18%
  * passing filter -
    * Alb: 99.34%
  * % adapter -
    * Alb: 0.88%
  * number of reads -
    * Alb: ~500k with 040 sample going up to 2.8 mil and 005 going up to 3.1 mil

### 4. Decontaminate `runFQSCRN_6.bash`

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#runFQSCRN_6.bash <indir; fp2 files> <outdir> <number of nodes running simultaneously>
#do not use trailing / in paths
bash ../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```
Once done, confirm that all files were successfully completed.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#FastQ Screen generates 5 files (*tagged.fastq.gz, *tagged_filter.fastq.gz, *screen.txt, *screen.png, *screen.html) for each input fq.gz file
#check that all 5 files were created for each file: 
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l 86
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 86
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l 86
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l 86
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l 86

#do all out files at once
grep 'error' slurm-fqscrn.*out
grep 'No reads in' slurm-fqscrn.*out
```
Everything looks good, no errors/missing files.
