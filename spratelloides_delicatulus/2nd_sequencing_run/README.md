# Sde 2nd Sequencing Run Processing Log

Working dir `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/2nd_sequencing_run`

[Sde slack channel](https://app.slack.com/client/TMJJ06SH0/CN65Y0WAJ/thread/CP0CYUUEN-1663780346.770149?cdn_fallback=1)

---

**Transfering data**

Normally, I use `scp` to transfer files from TAMUCC to  ODU (scp transfer one by one file) but for the 2nd Sde run, we generated over 1k data files so scp was not suited. 
I also could not set up a transfer using parallel bc my password was required for each file.

Solution:
Sharon put the files in the TAMUCC webshare which doesn't require a password. I then made the [gridDownloader.sh](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/gridDownloader.sh) to download 40 files in parallel, substancially increasing the spead of transfer.
 
September 2022,  transfer completed

---

## Step 0. Rename files for dDocent HPC

Raw data in
 `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/2nd_sequencing_run/raw_fq_capture` 


Used decode file from Sharon Magnuson & Chris Bird.

```bash
cd spratelloides_delicatulus/2nd_sequencing_run/raw_fq_capture

salloc
bash

#check got back sequencing data for all individuals in decode file
ls *gz | wc -l     # 1420
wc -l Sde_CaptureLibraries2_SequenceNameDecode.tsv  #355
# in this case,  individuals were sequenced in 2 diff  lanes so I have 4  files per sample.

#run renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sde_CaptureLibraries2_SequenceNameDecode.tsv
```

I noticed some files had extra characters in the new names  and it turns out that the decode files was missing this characters from the old names, causing the  problem

```
#  original
tail -n6 Sde_CaptureLibraries2_SequenceNameDecode.tsv
SdC0509505A	Sde-CVal_095_Ex1-cssl
SdC0509603E	Sde-CVal_096_Ex1-cssl
SdC02014	Sde-CHam_014_Ex1-cssl2
SdC02077	Sde-CHam_077_Ex1-cssl2
SdC01055	Sde-CMat_055_Ex1-cssl2
SdC01061	Sde-CMat_061_Ex1-cssl2

# fixed to
tail -n6 Sde_CaptureLibraries2_SequenceNameDecode.tsv
SdC0509505A     Sde-CVal_095_Ex1-cssl
SdC0509603E     Sde-CVal_096_Ex1-cssl
SdC0201405G	Sde-CHam_014_Ex1-cssl2
SdC0207706G	Sde-CHam_077_Ex1-cssl2
SdC0105510G	Sde-CMat_055_Ex1-cssl2
SdC0106112A	Sde-CMat_061_Ex1-cssl2
```
I also manually changed one individual from  Sde-AMar_061_Ex1_b-cssl2 to Sde-AMar_061_Ex1b-cssl2 to maintain consistency.

NOTEs: 
* "cssl2" individuals denote individuals that have been sequenced in multiple runs to control for lane effects. 
* "Ex1b" are individuals that half of the  extraction  was  originally kept at ODU (this  was later sent  to TAMUCC)

1 individual had 8 files
```
SdC0601502G_1_CKDL220019623-1A_H7TTHDSX5_L3_1.fq.gz
SdC0601502G_1_CKDL220019623-1A_H7TTHDSX5_L3_2.fq.gz
SdC0601502G_1_CKDL220019623-1A_H7TTHDSX5_L4_1.fq.gz
SdC0601502G_1_CKDL220019623-1A_H7TTHDSX5_L4_2.fq.gz
SdC0601502G_2_CKDL220019623-1A_H7TTHDSX5_L3_1.fq.gz
SdC0601502G_2_CKDL220019623-1A_H7TTHDSX5_L3_2.fq.gz
SdC0601502G_2_CKDL220019623-1A_H7TTHDSX5_L4_1.fq.gz
SdC0601502G_2_CKDL220019623-1A_H7TTHDSX5_L4_2.fq.gz
```

Check new nanmes
```
# Re-running renameFQGZ.bash first to make sure new names make sense
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sde_CaptureLibraries2_SequenceNameDecode.tsv
```

**Problem:** I have noticed that the script overlooks the lane info meaning that it will overwrite files of the same individual but different lanes.

**Solution:** I wrote the script [concat_diff_lanes.sh](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/concat_diff_lanes.sh) to concatenate the multiple files of one individual into a single file denoted by "LA" (all lanes) instead of L1, L2, L3, L4 etc

I am sending new concatenated files into a new directory just incase
```
sbatch concat_diff_lanes.sh concatenated_files
```

Checking that the concat script worked:
```
# script prints out a log with what it has done. Lets check it out:
less cat*out
```
Also, checking that I didn't lose data with du
```
# overall size of concatenated files
cd concatenated_names
du -sh

# overall size of original files
mkdir origiFiles
mv S*gz origiFiles
cd origiFiles
du -sh
```

Everything looks good! Have a single 1.fq.gz and a single 2.fq.gz file for each of the 354 individuals.

Note: Brendan modified renameFQGZ.bash so that it generates names with a single underscore given that the decode file has a single underscore in the new names too, which is not the case normally.

The easy fix is to modify the decode file:
```
sed -i 's/_E/-E/' Sde_CaptureLibraries2_SequenceNameDecode.tsv
```

Checking the new names again
```
cp renameFQGZ.bash concatenated_files
cp Sde_CaptureLibraries2_SequenceNameDecode.tsv concatenated_files
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sde_CaptureLibraries2_SequenceNameDecode.tsv
```
ok looks good! Renaming
```
#run renameFQGZ.bash again to actually rename files
#need to say "yes" 2X
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash NAMEOFDECODEFILE.tsv rename
```

---

**Checking quality of reads**

Running FASTQC
```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/2nd_sequencing_run/raw_fq_capture"
```

The initial MultiQC report with all the files [multiqc_report_fq.gz.html](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/Multi_FASTQC/multiqc_report_fq.gz.html) was merging files in some graphic making it hard to read (maybe because there were too many?)
,  so I re-run MultiQC for Albatross [multiqc_report_Alb.html](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/Multi_FASTQC/Alb_fastqc/multiqc_report_Alb.html)
and Contemporary files [multiqc_report_Contem.html](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/Multi_FASTQC/Con_fastqc/multiqc_report_Contem.html) separately.

Viewing options: (1) Download files from the above links, (2) copy and paste raw code of reports (click "View raw" from the links above), (3) copy the URL that shows the raw code and enter it in the  [GitHub & BitBucket HTML Preview webpage](https://htmlpreview.github.io/?).


SdA01 files are from Sde-AMat		Match ID:  MatB

SdA02 files are from Sde-AMar           Match ID:  PMar

SdC01 files are from Sde-CMat           Match ID:  MatB 

SdC02 files are from Sde-CHam           Match ID:  PMar

**Highlights:**

Sde-AMat Duplication 70-80%s, GC most 40%s few 50%s, Num of Reads 2-38 M (most in the 10-20s M)

Sde-AMar Duplication 70-80%s(only one file ~60%), GC 50-60%s, Num of Reads 2-12 M (most <10 M)

Sde-CMat Duplication 70-80%s, GC mostly 40%s, Num of Reads 1.3-37 M (most in the 10-20s M)

Sde-CHam Duplication 50-80%s(few 40%s), GC mostly 40%s, Num of Reads <1-10 M (great majority <1 M)


**Noticible dicotomy of sequence results across the 2 locations**

Major differences do not correlate with era but with location:

Matnog Bay (Southern Luzon); MatB=SdA01:Sde-AMat,  SdC01:Sde-CMat; normal GC content and good amounts of reads

Port Maricaban (Northern Luzon); PMar=SdA02:Sde-AMar, SdC02:Sde-CHam; higer GC content and subtantially less sequences than MatB


Potential reasons could be library effects (need to check how populations were prepare) or lot effects.


---

## Step 1.  1st fastp

Running the first trim (3'):
```
cd /home/e1garica/pire_cssl_data_processing/spratelloides_delicatulus
#runFASTP_1.sbatch <indir> <outdir>
# do not use trailing / in paths
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch "raw_fq_capture" "./fq_fp1"
```

**Results below are not for  Sde. STILL HAVENT ASSESS THIS**

[Report](https://htmlpreview.github.io/?https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/fq_fp1/1st_fastp_report.html), download and open in web browser. You can either scp it to your local computer or copy the raw file, paste it into notepad++ and save as html.  

Potential issues:  
* % duplication - high for albatross, 
  * alb:70s, contemp: 50s
* gc content - reasonable
* passing filter - good
* % adapter - high, but that was expected, 
  * alb: 80s, contemp: 40s
* number of reads - decent
  * generally more for albatross than contemp, as we attempted to do
  * alb: 30mil, contemp: 8 mil
 
---

bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmparray /scratch/e1garcia 58

mv spratelloides_delicatulus/*out spratelloides_delicatulus/logs/

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmparray fq_fp1_clmparray_fp2

## FASTQ SCREEN

Running files that were dropped
```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01007_CKDL210020579-1a-5UDI301-AK10343_HKGLMDSX2_L2_clmp.fp2_r2.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01016_CKDL210020579-1a-AK7758-AK4234_HKGLMDSX2_L2_clmp.fp2_r1.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01017_CKDL210020579-1a-AK7758-GD06_HKGLMDSX2_L2_clmp.fp2_r2.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01018_CKDL210020579-1a-AK7078-AK533_HKGLMDSX2_L2_clmp.fp2_r2.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01026_CKDL210020579-1a-AK9143-AK533_HKGLMDSX2_L2_clmp.fp2_r1.fq.gz
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmparray_fp2 fq_fp1_clmp_fp2_fqscrn 1 SdA01027_CKDL210020579-1a-AK9143-AK7557_HKGLMDSX2_L2_clmp.fp2_r1.fq.gz
```

MultiQC on screend files
```
sbatch ../scripts/runMULTIQC.sbatch fq_fp1_clmparray_fp2_fqscrn multiqc_fqscrn_Sde_capture
```

Link to view report:
[multiqc_fscrn_Sde_capture_report](https://htmlpreview.github.io/?https://raw.githubusercontent.com/philippinespire/pire_cssl_data_processing/main/spratelloides_delicatulus/fq_fp1_clmparray_fp2_fqscrn/1st_multiqc_fqscrn_Sde_capture.html?token=GHSAT0AAAAAABQH4M6IECPNRYGKYBDK3WUEYTIBMSA)

If the above link doesn't load succesfully download the report [here](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/spratelloides_delicatulus/fq_fp1_clmparray_fp2_fqscrn/1st_multiqc_fqscrn_Sde_capture.html) and open locally. 

## Repaired
```
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmparray_fp2_fqscrn fq_fp1_clmparray_fp2_fqscrn_repaired 40
```

## Renaming Files to dDocentHPC format

Moving decode files into Species dir:
```
mv raw_fq_files/Sde_CaptureLibraries_SequenceNameDecode.tsv . 
```

Creating decode_newnames files:
```
bash ../scripts/mkNewFileNames.bash Sde_CaptureLibraries_SequenceNameDecode.tsv fq_fp1_clmparray_fp2_fqscrn_repaired > decode_newnames.txt
```

This resulting file contained an empty line at the top and was mixing directories with file names creating the old and new names not to align in the decode file (in subsequent code). Ex:
less -S decode_newnames.txt 
```

Sde-AMat_001_Ex1-fq_fp1_clmparray_fp2_fqscrn_repaired/SdA01001_CKDL210020579-1a-5UDI301-AK533_HKGLMDSX2_L2_clmp.fp2_repr.R1.fq.gz
Sde-AMat_001_Ex1-fq_fp1_clmparray_fp2_fqscrn_repaired/SdA01001_CKDL210020579-1a-5UDI301-AK533_HKGLMDSX2_L2_clmp.fp2_repr.R2.fq.gz
```

We might have to change the mkNewFileNames script but for now, I needed to move forward with Sde so I fixed this for my file manually:
```
less -S decode_newnames.txt | tail -n +2 | sed 's/_Ex.*\//-/' | cut -d "_" -f 1-2,5-7 | sed -e 's/_c/-c/' -e 's/_r/-r/' -e 's/_L/-L/' -e 's/\.f/-f/' > decode_newnames_fixed.txt

less -S decode_newnames_fixed.txt
Sde-AMat_001-SdA01001-L2-clmp-fp2-repr.R1.fq.gz
Sde-AMat_001-SdA01001-L2-clmp-fp2-repr.R2.fq.gz
Sde-AMat_002-SdA01002-L2-clmp-fp2-repr.R1.fq.gz
Sde-AMat_002-SdA01002-L2-clmp-fp2-repr.R2.fq.g
...
```

and continue with current code 
```
ls fq_fp1_clmparray_fp2_fqscrn_repaired/*fq.gz > decode_oldnames.txt
module load parallel
bash
parallel --no-notice --link -kj6 "echo {1}, {2}" :::: decode_oldnames.txt decode_newnames_fixed.txt > decode_translation.csv
less -S decode_translation.csv
mkdir mkBAM
parallel --no-notice --link -kj6 "mv {1} mkBAM/{2}" :::: decode_oldnames.txt decode_newnames_fixed.txt
```

## Maping mkBAM

Permission denided when clonig dDocentHPC repo. Thus, using that already in Lle.

**Reference:** Normally this will be the "best" assembly from the SSL pipeline but Sde goes back to the RAD.

Thus, I am using the reference that was sent to Arbor Bio, transferred from TAMUCC to ODU:
```
scp /work/hobi/webshare/PIRE_ProbeTargets/03_Spratelloides_delicatulus/PIRE_SpratelloidesDelicatulus.D.3.3.probes4development.noMSATS.noNNNN.224-519bp.0-8TGCAGG.lessthan2in$
cp PIRE_SpratelloidesDelicatulus.D.3.3.probes4development.noMSATS.noNNNN.224-519bp.0-8TGCAGG.lessthan2indelsof3nt.fasta ~/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/mkBAM/reference.rad.D-3-3-probes4development-noMSATS-noNNNN-224-519bp-0-8TGCAGG-lessthan2indelsof3nt.fasta
```

Copying Config from species dir:
```
cp /home/cbird/pire_cssl_data_processing/scripts/dDocentHPC/configs/config.5.cssl mkBAM
```

Renamed reference and changed cutoff settings in config but leave other settings as is:
```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=dd$
0.9             cdhit Clustering_Similarity_Pct (0-1)                                                   Use cdhit to cluster and collapse uniq reads by similarity threshold
rad               Cutoff1 (integer)                                                                                         Use unique reads that have at least this much co$
D-3-3-probes4development-noMSATS-noNNNN-224-519bp-0-8TGCAGG-lessthan2indelsof3nt               Cutoff2 (integer)
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

----------fltrBAM: Settings for filtering mapping alignments in the *bam files---------------
20              samtools view -q        Mapping_Min_Quality (integer)                   Remove reads with mapping qual less than this value
yes             samtools view -F 4      Remove_unmapped_reads? (yes,no)                 Since the reads aren't mapped, we generally don't need to filter them
no              samtools view -F 8      Remove_read_pair_if_one_is_unmapped? (yes,no)   If either read in a pair does not map, then the other is also removed
yes             samtools view -F 256    Remove_secondary_alignments? (yes,no)           Secondary alignments are reads that also map to other contigs in the reference$
no              samtools view -F 512    Remove_reads_not_passing_platform_vendor_filters (yes,no)               We generally don't see any of these
no              samtools view -F 1024   Remove_PCR_or_optical_duplicates? (yes,no)      You probably don't want to set this to yes
no              samtools view -F 2048   Remove_supplementary_alignments? (yes,no)       We generally don't see any of these
no              samtools view -f 2      Keep_only_properly_aligned_read_pairs? (yes,no)                         Set to no if OL mode
0               samtools view -F        Custom_samtools_view_F_bit_value? (integer)                             performed separately from the above, consult samtools $
0               samtools view -f        Custom_samtools_view_f_bit_value? (integer)                             performed separately from the above, consult samtools $
30                                      Remove_reads_with_excessive_soft_clipping? (no, integers by 10s)        minimum number of soft clipped bases in a read that is$
30                                      Remove_reads_with_alignment_score_below (integer)               Should match bwa mem -T, which sometimes doesn't work
no                                      Remove_reads_orphaned_by_filters? (yes,no)
------------------------------------------------------------------------------------------------------------------
```

 Then copied scripts bc lack of permissions.
```
cp /home/cbird/pire_cssl_data_processing/scripts/dDocentHPC.sbatch .
cp /home/cbird/pire_cssl_data_processing/scripts/dDocentHPC/dDocentHPC.bash .
```

and change the paths in the sbatch:
```
#!/bin/bash -l

#SBATCH --job-name=mkBAM-mkVCF
#SBATCH -o mkBAM-fltrBAM-mkVCF-%j.out
#SBATCH -p main
#SBATCH -c 40

enable_lmod
module load container_env ddocent

CONFIG=$1

crun bash dDocentHPC.bash mkBAM $CONFIG

#this will use dDocent fltrBAM to filter the BAM files
crun bash dDocentHPC.bash fltrBAM $CONFIG

#this will use freebayes to genotype the bam files and make a VCF
crun bash dDocentHPC.bash mkVCF $CONFIG
```

Running
```
sbatch dDocentHPC.sbatch config.5.cssl
```
