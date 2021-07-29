# Aen Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Atherinomorus endrachtensis* samples from Hamilo Cove.

---

## Step 1.  1st fastp

Raw data in `/home/e1garcia/shotgun_PIRE/Aen/raw_fq` (check Atherinomorus-endrachtensis channel on Slack).  The root outdir for all analyses will be  `/home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus-endrachtensis`. Both on Wahab/Turing (ODU HPCs).

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFASTP_1.sbatch <indir> <outdir>
sbatch runFASTP_1.sbatch /home/e1garcia/shotgun_PIRE/Aen/raw_fq fq_fp1
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - high for most but not all Albatross, lower for contemporary
  * Alb: ~60% (some in the 40s), Contemp: ~45%
* GC content - good
  * Alb: 40%, Contemp: 45%
* passing filter - most reads passed filters for both Albatross & contemporary
  * Alb: >90% (some closer to 50-60% and those tend to be ones with lower % dup), Contemp: ~95%
* % adapter - high, esp. for Albatross
  * Alb: 80%, Contemp: 30-40%
* number of reads - seems to be okay
  * Alb: generally much higher # (>40 mil) BUT some are very low (1-2 mil), Contemp: ~10-20 mil

---

## Step 2. Clumpify

```
#on Turing
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

enable_lmod
#runCLUMPIFY_r1r2.sbatch <indir> <outdir> <tempdir>
sbatch runCLUMPIFY_r1r2.sbatch fq_fp1 fq_fp1_clmp /scratch-lustre/r3clark
```

Checked that all files ran with `checkCLUMPIFY.R`. All ran (no RAM issues).

---

## Step 3. Run fastp2

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFASTP_2.sbatch <indir> <outdir>
sbatch runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1_clmp_fp2/2nd_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:  
* % duplication - good
  * Alb: ~10%, Contemp: ~10%
* GC content - good
*  Alb: 40%, Contemp: 45%
* passing filter - good
  * Alb: ~98%, Contemp: ~99%
* % adapter - good
  * Alb: <2%, Contemp: <1%
* number of reads - took a hit, especially Albatross
  * Alb: about half ~10-25 mil & about half ~1-7 mil, Contemp: 5-10 mil

---

## Step 4. Run fastq_screen

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runFQSCRN_6.bash <indir> <outdir> <number of nodes to run simultaneously>
bash ../scripts/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20

#check output for errors
grep 'error' slurm-fqscrn.266930*out | less -S #nothing
grep 'error' slurm-fqscrn.266930*out | less -S #nothing
```

[Report](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/atherinomorus_endrachtensis/fq_fp1_clmp_fp2_fqscrn/fqscrn_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.

Potential issues:
* None. Not many hits to other genomes. What did hit was to bacteria/protist and Albatross generally slightly more contam than contemp.

Cleanup logs

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

mkdir logs
mv *out logs
```
---

## Step 5. Repair fastq_screen paired end files

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#runREPAIR.sbatch <indir> <outdir> <threads>
sbatch ruNREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_repaired 40
```

---

## Step 6. Rename files for dDocent HPC and put into mapping dir

Used decode file from Sharon Magnuson & Chris Bird.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis

#mkNewFileNames.bash <decode file name> <fqdir>
bash ../scripts/mkNewFileNames.bash Aen_CaptureLibraries_SequenceNameDecode.txv fq_fp1_clmp_fp2_fqscrn_repaired > decode_newnames.txt

#make old file names
ls fq_fp1_clmp_fp2_fqscrn_repaired/*fq.gz > decode_oldnames.txt

#triple check that the old and new files are aligned
module load parallel
bash
parallel --no-notice --link -kj6 "echo {1}, {2}" :::: decode_oldnames.txt decode_newnames.txt > decode_translation.csv
less -S decode_translation.csv

#rename files and move to mapping dir
mkdir mkBAM
parallel --no-notice --link -kj6 "mv {1} mkBAM/{2}" :::: decode_oldnames.txt decode_newnames.txt

#confirm success
ls mkBAM
```

---

## Step 7.  Set up mapping dir and get reference genome

Cloned dDocentHPC repo.

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/scripts
git clone git@github.com:cbirdlab/dDocentHPC.git

cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis
cp ../scripts/dDocentHPC/configs/config.5.cssl mkBAM
```

Because there is no whole genome reference for *A. endrachtensis*, I am using the full "raw" reference fasta from the RAD data used to make probes.

```
#the destination reference fasta should be named as follows: reference.<assembly type>.<unique assembly info>.fasta
#<assembly type> is `ssl` for denovo assembled shotgun library or `rad` for denovo assembled rad library
#this naming is a little messy, but it makes the ref 100% tracable back to the source
#it is critical not to use `_` in name of reference for compatibility with ddocent and freebayes

mv /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM/PIRE_AtherinomorousEndrachtensis.A.6.6.probes4development.fasta reference.rad.RAW-6-6.fasta
```

Updated the config file with the ref genome info

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM
nano config.5.cssl
```

Inserted `<assembly type>` into `Cutoff1` variable and `<unique assembly info>` into `Cutoff2` variable

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
rad               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much coverage for making the reference     genome
RAW-6-6               Cutoff2 (integer)
                Use unique reads that occur in at least this many individuals for making the reference genome
0.05    rainbow merge -r <percentile> (decimal 0-1)                                             Percentile-based minimum number of seqs to assemble in a precluster
0.95    rainbow merge -R <percentile> (decimal 0-1)                                             Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------

----------mkBAM: Settings for mapping the reads to the reference genome-------------------------------------------
Make sure the cutoffs above match the reference*fasta!
1               bwa mem -A Mapping_Match_Value (integer)
4               bwa mem -B Mapping_MisMatch_Value (integer)
6               bwa mem -O Mapping_GapOpen_Penalty (integer)
30              bwa mem -T Mapping_Minimum_Alignment_Score (integer)                    Remove reads that have an alignment score less than this.
5       bwa mem -L Mapping_Clipping_Penalty (integer,integer)
------------------------------------------------------------------------------------------------------------------
```

---

### Step 8. Map reads to reference - Filter Maps - Genotype Maps

```
cd /home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM

#this has to be run from dir with fq.gz files to be mapped and the ref genome
#this script is preconfigured to run mapping, filtering of the maps, and genotyping in 1  shot
sbatch ../dDocentHPC.sbatch config.5.cssl
```
