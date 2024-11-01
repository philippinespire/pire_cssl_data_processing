The resequencing cssl data are back and can be found on the TAMUCC HPC at https://gridftp.tamucc.edu/genomics/20230123_PIRE-Leq-capture2/ The sequence name decode sheet is in with the data.
Note there is an updated naming scheme that is formatted as Extraction_id-LibraryPlateWell-LibraryType-Library_id-SeqRun. Extraction_ID is the sample name and extraction from the Extraction database, LibraryPlateWell is the well that the library was processed in. LibraryType is ssl, cssl, or lcwgs. Library_id refers to which library was used (sometimes there were multiple libraries made for an individual). SeqRun is the number of times that individual has been sequenced for this library type

### Leq 2nd cssl run

### 0. Cleaning up and renaming

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

---

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

---

### 2. First trim

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

---

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

Ran `runMULTIQC.sbatch` to get MultiQC output

```
/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#sbatch Multi_FASTQC.sh "<indir>" "<mqc report name>" "<file extension to qc>"
#do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"
```

---

### 4. Second trim. Execute `runFASTP_2.sbatch`

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#sbatch runFASTP_2_cssl.sbatch <indir; clumpified files> <outdir>
#do not use trailing / in paths
sbatch ../../../pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

Potential issues:
  * % duplication -
    * Alb: 4.87%, Contemp: 8.30%
  * GC content -
    * Alb: 46.46%, Contemp: 44.78%
  * passing filter -
    * Alb: 99.60%, Contemp: 99.67%
  * % adapter -
    * Alb: 0.40%, Contemp: 0.57%
  * number of reads -
    * Alb: ~4 mil, Contemp: ~300k

---

### 5. Decontaminate runFQSCRN_6.bash
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#runFQSCRN_6.bash <indir; fp2 files> <outdir> <number of nodes running simultaneously>
#do not use trailing / in paths
bash ../../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20
```
One sample stalled and had to be rerun individually
```
bash ../../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 1 Leq-ABas_009_Ex1-5D5D-cssl-1and2-2.clmp.fp2_r1.fq.gz
```
The sample succesfully ran.
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#FastQ Screen generates 5 files (*tagged.fastq.gz, *tagged_filter.fastq.gz, *screen.txt, *screen.png, *screen.html) for each input fq.gz file
#check that all 5 files were created for each file: 
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l 104
ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 104
ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l 104
ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l 104
ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l 104

#do all out files at once
grep 'error' slurm-fqscrn.*out
grep 'No reads in' slurm-fqscrn.*out

#for the individual job for Leq-ABas_009_Ex1-5D5D-cssl-1and2-2.clmp.fp2_r1
grep 'error' slurm-fqscrn.1241320.0*out
 grep 'No reads in' slurm-fqscrn.1241320.0*out
```
Everything looks good, no errors/missing files.

Ran `runMULTIQC.sbatch` to get the MultiQC output.

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/siganus_spinus/2nd_sequencing_run

#sbatch runMULTIQC.sbatch <indir; fqscreen files> <report name>
#do not use trailing / in paths
sbatch ../../../pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastq_screen_report
```
Potential issues:
* one hit, one genome, no ID - 
 Alb: ~85%
* no one hit, one genome to any potential contaminators (bacteria, virus, human, etc) -
 Alb: ~15%
 
---

### 6. Execute runREPAIR.sbatch 

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#runREPAIR.sbatch <indir; fqscreen files> <outdir> <threads>
sbatch ../../../pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_rprd 40
```

Ran `Multi_FASTQC.sh` separately.
```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run

#sbatch Multi_FASTQC.sh "<indir>" "<output report name>" "<file extension>"
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "./fq_fp1_clmp_fp2_fqscrn_rprd" "fqc_rprd_report" "fq.gz"
```

Potential issues:
* % duplication -
Alb: 3.77%, Contemp: 8.82%
* GC content -
Alb: 45%, Contemp: 44%
* number of reads -
Alb: ~1 mil, Contemp: ~120 mil

---

### 7. Set up mapping dir and get reference genome

Make mapping directory and move `*fq.gz` files over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run
ln fq_fp1_clmp_fp2_fqscrn_rprd/*fq.gz mkBAM
```

Copied best genome from 1st sequencing run to maintain consistency.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/mkBAM
cp ../../1st_sequencing_run/mkBAM/reference.rad.RAW-2-2.fasta .
```

Copied `config.6.rad` 

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/mkBAM
cp /home/e1garcia/shotgun_PIRE/dDocentHPC/configs/config.6.rad .
```

Update `config.6.rad`. Check to see if mkBAM settings can remain consistent with the 1st sequencing run and run without error.

```sh
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE
0.9             cdhit Clustering_Similarity_Pct (0-1)                                                   Use cdhit to cluster and collapse uniq reads 
rad             Cutoff1 (integer)                                                                                               Use unique reads that
RAW-2-2         Cutoff2 (integer)                                                                                               Use unique reads that
0.05    rainbow merge -r <percentile> (decimal 0-1)                                             Percentile-based minimum number of seqs to assemble i
0.95    rainbow merge -R <percentile> (decimal 0-1)                                             Percentile-based maximum number of seqs to assemble i
------------------------------------------------------------------------------------------------------------------
```

---

### 8. Map reads to reference - Filter Maps - Genotype Maps

Had to copy and edit `dDocentHPC_dev2.sbatch` in order to run in the 2nd sequencing run directory (just added another ../ to command). The script was saved as `dDocentHPC_dev2_multipleruns.sbatch`.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/leiognathus_equula/2nd_sequencing_run/mkBAM

#this script has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1 shot
sbatch dDocentHPC_dev2_multipleruns.sbatch mkBAM config.6.rad
sbatch dDocentHPC_dev2_multipleruns.sbatch fltrBAM config.6.rad
```

Stopped here as the 1st and 2nd sequencing run was combined and ran through filtering and pop structure steps together (see main LEQ readME for more information)
