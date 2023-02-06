The resequencing cssl data are back and can be found on the TAMUCC HPC at https://gridftp.tamucc.edu/genomics/20230123_PIRE-Leq-capture2/ The sequence name decode sheet is in with the data.
Note there is an updated naming scheme that is formatted as Extraction_id-LibraryPlateWell-LibraryType-Library_id-SeqRun. Extraction_ID is the sample name and extraction from the Extraction database, LibraryPlateWell is the well that the library was processed in. LibraryType is ssl, cssl, or lcwgs. Library_id refers to which library was used (sometimes there were multiple libraries made for an individual). SeqRun is the number of times that individual has been sequenced for this library type

### Leq 2nd cssl run

## 0. Cleaning up and renaming

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

Some did not work (mostly contemporaries!) and stalled the MULTIQC procedure. Running these with SingleQC and performing MultiQC separately.

```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-ABas_020_Ex1-4H-cssl-1-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-ABas_020_Ex1-4H-cssl-1-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_006-Ex1-5E-cssl-1-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_006-Ex1-5E-cssl-1-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_020-Ex1-2A-cssl-1-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_020-Ex1-2A-cssl-1-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_030-Ex1-8G-cssl-1-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_030-Ex1-8G-cssl-1-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_042-Ex1-6A-cssl-1-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_042-Ex1-6A-cssl-1-2.2.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_058-Ex1-2B-cssl-1-2.1.fq.gz"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Single_FASTQC_noparallel.sh "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" "Leq-CMig_058-Ex1-2B-cssl-1-2.2.fq.gz"

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/fq_raw" fastqc_report
```

Summary [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/leiognathus_equula/2nd_sequencing_run/fq_raw/fastqc_report.html):
* Mostly > 500K sequences; up to 6M. Contemporaries low.
* Quality good
* Some yellow-flags for GC content - minor contamination?
* Duplication not too bad! ~20% for Albatross, ~40% for contemp
* High adapter content

## 2. First trim

```
cd cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/

#sbatch runFASTP_1st_trim.sbatch <indir> <outdir>
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
```

Summary [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/leiognathus_equula/2nd_sequencing_run/fq_fp1/1st_fastp_report.html):
* Low duplication, low-moderate adapter content
* GC content pretty stable
* ≥94% passed filter

### 3. Clumpify / remove duplicates

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#runCLUMPIFY_r1r2_array.bash <indir; fast1 files> <outdir> <tempdir> <max # of nodes to use at once>
#do not use trailing / in paths
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/breid 20
```

Check clumpify.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2

cp /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R .

crun R < checkClumpify_EG.R --no-save
exit #to relinquish the interactive node
```

Clumpify Successfully worked on all samples!
