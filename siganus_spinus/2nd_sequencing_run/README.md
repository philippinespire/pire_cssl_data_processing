The Ssp-A resequencing cssl data are back and can be found at https://gridftp.tamucc.edu/genomics/20230123_PIRE-Ssp-A-capture2/ The sequence name decode sheet is in with the data.
Note there is an updated naming scheme that is formatted as Extraction_id-LibraryPlateWell-LibraryType-Library_id-SeqRun. Extraction_ID is the sample name and extraction from the Extraction database, LibraryPlateWell is the well that the library was processed in. LibraryType is ssl, cssl, or lcwgs. Library_id refers to which library was used (sometimes there were multiple libraries made for an individual). SeqRun is the number of times that individual has been sequenced for this library type.

## 2nd sequencing run

### Rename and back up

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

### MultiQC

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

Summary:
* Mostly <1M, though two have ~8M
* Quality good
* GC content all over the place, some look very bad / almost all contamination!
* High duplication (~60-90%) and adapter content.
