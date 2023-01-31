The resequencing cssl data are back and can be found on the TAMUCC HPC at https://gridftp.tamucc.edu/genomics/20230123_PIRE-Leq-capture2/ The sequence name decode sheet is in with the data.
Note there is an updated naming scheme that is formatted as Extraction_id-LibraryPlateWell-LibraryType-Library_id-SeqRun. Extraction_ID is the sample name and extraction from the Extraction database, LibraryPlateWell is the well that the library was processed in. LibraryType is ssl, cssl, or lcwgs. Library_id refers to which library was used (sometimes there were multiple libraries made for an individual). SeqRun is the number of times that individual has been sequenced for this library type

### Leq 2nd cssl run

## Cleaning up and renaming

First remove some files that are of uncertain origin according to Sharon.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw
rm LeA01007*
rm LeA01041*
rm LeA01045*
rm LeA01047*
rm LeA01054*
rm LeA01055*
```

Run test rename.

```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Leq_CaptureLibraries2_SequenceNameDecode.tsv
```

Looks good - rename!

```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Leq_CaptureLibraries2_SequenceNameDecode.tsv rename
```

Back up renamed files.

```
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw_cssl/
cp /home/e1garica/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/raw_fq_capture/* /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw_cssl/
```

### 1. Run MultiQC

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "fq.gz"
```
