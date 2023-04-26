
# Sde Data Processing Log

Working dir `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus`

September 2022,  we have received the 2nd sequencing run for Sde. Progress for the 2nd run can be followed [here](https://github.com/philippinespire/pire_cssl_data_processing/tree/main/spratelloides_delicatulus/2nd_sequencing_run)

---

**Checking quality of reads**

Running FASTQC
```sh
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq.gz" "/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/raw_fq_capture/"
```

For some reason FASTQC was getting stuck. I modified the script to run only missing files.

Looks like FASTQC could not process `SdC02092_CKDL210020579-1a-AK7010-7UDI246_HKGLMDSX2_L2_1.fq.gz` this time around. The script kept geting stuck at this file. The previous runs might had getting stuck at other files. Before noticing this, I was not keeping all the failed out files. Check the output for inconsistencies. 

Ended up running FASTQC directly on current session (not with sbatch), and that ran fine.

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

## Mapping with dDocentHPC_dev2 and config.6

So mapping results were not great with normal dDocentHPC and config5 so we are trying the new dDocentHPC_dev2 and config.6

First, I ran all the data with default settings for config.6 in `mkBAM_config6`
```
----------trimFQ: Settings for Trimming FASTQ Files---------------------------------------------------------------
146             trimmomatic MINLEN (integer, mkREF only)                                                Drop the read if it is below a specified length. Set to the length 
33              trimmomatic MINLEN (integer, mkBAM only)                                                Drop the read if it is below a specified length. Set to the minimum
20              trimmomatic LEADING:<quality> (integer, mkBAM only)                             Specifies the minimum quality required to keep a base.
15              trimmomatic TRAILING:<quality> (integer, mkREF only)                    Specifies the minimum quality required to keep a base.
20              trimmomatic TRAILING:<quality> (integer, mkBAM only)                    Specifies the minimum quality required to keep a base.
TruSeq3-PE-2.fa trimmomatic ILLUMINACLIP:<fasta> (0, fasta file name)                   Specifies the trimmomatic adapter file to use. entering a 0 (zero) will turn off ad
2               trimmomatic ILLUMINACLIP:<seed mismatches> (integer)                    specifies the maximum mismatch count which will still allow a full match to be perf
30              trimmomatic ILLUMINACLIP:<palindrome clip thresh> (integer)             specifies how accurate the match between the two 'adapter ligated' reads must be fo
10              trimmomatic ILLUMINACLIP:<simple clip thresh> (integer)                 specifies how accurate the match between any adapter etc. sequence must be against 
20              trimmomatic SLIDINGWINDOW:<windowSize> (integer)                                specifies the number of bases to average across
20              trimmomatic SLIDINGWINDOW:<windowQuality> (integer)                             specifies the average quality required.
0               trimmomatic CROP:<bp to keep> (integer, mkBAM only)    Trim read sequences down to this length. Enter 0 for no cropping
0               trimmomatic HEADCROP:<length> (integer, only Read1 for ezRAD)   The number of bases to remove from the start of the read. 0 for ddRAD, 5 for ezRAD
no              FixStacks (yes,no)                                                                                      Demultiplexing with stacks introduces anomolies.  T
------------------------------------------------------------------------------------------------------------------

----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE              Type of reads for assembly (PE, SE, OL, RPE)                                    PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=d
0.9             cdhit Clustering_Similarity_Pct (0-1)                                                   Use cdhit to cluster and collapse uniq reads by similarity threshol
rad             Cutoff1 (integer)                                                                                               Use unique reads that have at least this mu
sde             Cutoff2 (integer)                                                                                               Use unique reads that occur in at least thi
0.05    rainbow merge -r <percentile> (decimal 0-1)                                             Percentile-based minimum number of seqs to assemble in a precluster
0.95    rainbow merge -R <percentile> (decimal 0-1)                                             Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------

----------mkBAM: Settings for mapping the reads to the reference genome-------------------------------------------
Make sure the cutoffs above match the reference*fasta!
1               bwa mem -A Mapping_Match_Value (integer)                                                bwa mem default is 1
4               bwa mem -B Mapping_MisMatch_Value (integer)                                     bwa mem default is 4
6               bwa mem -O Mapping_GapOpen_Penalty (integer)                                    bwa mem default is 6
13              bwa mem -T Mapping_Minimum_Alignment_Score (integer)                    bwa mem default is 30. Remove reads that have an alignment score less than this. do
5       bwa mem -L Mapping_Clipping_Penalty (integer,integer)                   bwa mem default is 5
------------------------------------------------------------------------------------------------------------------

----------fltrBAM: Settings for filtering mapping alignments in the *bam files---------------
30              samtools view -q                Mapping_Min_Quality (integer)                                                                           Remove reads with m
yes             samtools view -F 4              Remove_unmapped_reads? (yes,no)                                                                         Since the reads are
no              samtools view -F 8              Remove_read_pair_if_one_is_unmapped? (yes,no)                                           If either read in a pair does not m
yes             samtools view -F 256    Remove_secondary_alignments? (yes,no)                                                           Secondary alignments are reads that
no              samtools view -F 512    Remove_reads_not_passing_platform_vendor_filters (yes,no)               We generally don't see any of these
no              samtools view -F 1024   Remove_PCR_or_optical_duplicates? (yes,no)                                              You probably don't want to set this to yes
yes             samtools view -F 2048   Remove_supplementary_alignments? (yes,no)                                               We generally don't see any of these
no              samtools view -f 2              Keep_only_properly_aligned_read_pairs? (yes,no)                                         Set to no if OL mode 
0               samtools view -F                Custom_samtools_view_F_bit_value? (integer)                                             performed separately from the above
0               samtools view -f                Custom_samtools_view_f_bit_value? (integer)                                             performed separately from the above
no              Remove_reads_with_excessive_soft_clipping? (no, integers)                       minimum number of soft clipped bases in a read, summed between the beginnin
50              Remove_reads_with_alignment_score_below_relative_threshold (integer)    Alignment score thresholds are calculated based on this value adjusted by a factor 
100             Read_length_assumed_by_relative_alignment_score_threshold (integer)     Alignment score thresholds are calculated based on the threshold in the previous se
no              Remove_reads_orphaned_by_filters? (yes,no)
------------------------------------------------------------------------------------------------------------------
```

Then, run coverage scripts and compared results with config.5 by clonning the repo locally and running the r scripts in (process_sequencing_metadata)[https://github.com/philippinespire/process_sequencing_metadata]

For example, for 2nd_run:
```
pwd
/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/2nd_sequencing_run/

sbatch ../../scripts/getBAITcvg.sbatch ./mkBAM_config_6 /home/e1garcia/shotgun_PIRE/pire_probe_sets/03_Spratelloides_delicatulus/Spratelloides_Chosen_baits.singleLine.bed
Submitted batch job 1355887

cd mkBAM_config_6
sbatch ../../../../pire_fq_gz_processing/mappedReadStats.sbatch . coverageMappedReads
```


**Results were a bit better with config.6 but the overall story is the same**

Next, I tried playing with few of the fltrBAM settings.

 To do this, I selected one of the largest and smallest BAM files per population and and redo mkBAM with 4 different config.6 with different vatioations in the following settings::
```
config6 = default config6 setting

no      samtools view -F 8            Remove_read_pair_if_one_is_unmapped? (yes,no)  
no      samtools view -f 2            Keep_only_properly_aligned_read_pairs? (yes,no) 
no      Remove_reads_orphaned_by_filters? (yes,no)

config6-1

yes      samtools view -F 8            Remove_read_pair_if_one_is_unmapped? (yes,no)  
no       samtools view -f 2            Keep_only_properly_aligned_read_pairs? (yes,no) 
yes      Remove_reads_orphaned_by_filters? (yes,no)

config6-2

no       samtools view -F 8            Remove_read_pair_if_one_is_unmapped? (yes,no)  
yes      samtools view -f 2            Keep_only_properly_aligned_read_pairs? (yes,no) 
no       Remove_reads_orphaned_by_filters? (yes,no)

config6-3

yes      samtools view -F 8            Remove_read_pair_if_one_is_unmapped? (yes,no)  
yes      samtools view -f 2            Keep_only_properly_aligned_read_pairs? (yes,no) 
yes      Remove_reads_orphaned_by_filters? (yes,no)
```

Ran the coverage scripts and the r scripts from process metadata

**Results**

In a nutshell, setting a yes in:
```
 yes          samtools view -f 2            Keep_only_properly_aligned_read_pairs? (yes,no) 
```
affects mostly the large BAM files making them to decrease in number of mapped reads, mean mapped read depth, genome coverage,  but also a decrease on coverage and depth in targets 

At least for Sde, these two didn't change results
```
yes/no      samtools view -F 8            Remove_read_pair_if_one_is_unmapped? (yes,no)  
yes/no      Remove_reads_orphaned_by_filters? (yes,no)
```
Thus, results for config6 and config6-1 are very similar, and results for config6-2 and -3 are very similar (worse)

We still suspect that the RAD reference might be problematic for the mapping. 
Thus, in the next step I will put one of the best C-individuals (Sde-CMat_087) though SPAdes, remap with this new ref and config6 default settings, run coverage and r scripts to compare results.


---

Just noticed that I have not run config6 in 2nd_sequencing_run. So I ran that and also merging the bam files in common between 1st and 2nd seq runs

### Merging BAMs

See (pire_cssl_data_processing)[https://github.com/philippinespire/pire_cssl_data_processing] for details. 

Original mkBAM were made with config5 so renamed those first
```
pwd
/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/
mv mkBAM mkBAM_config5
mv 2nd_sequencing_run/mkBAM 2nd_sequencing_run/mkBAM_config5
```

I made temp dir to fit Brendan's scripts
```
mkdir 1st_sequencing_run/
mkdir 1st_sequencing_run/mkBAM
```

Moved the duplicated -RG.bams from mkBAM_config6 into mkBAM (temp dir for merging)
```
mv mkBAM_config6/<files> mkBAM
mv 2nd_sequencing_run/mkBAM_config6/<files> 2nd_sequencing_run/mkBAM

#Files
Sde-AMar_055*-RG.bam
Sde-AMar_061*-RG.bam
Sde-AMat_002*-RG.bam
Sde-AMat_005*-RG.bam
Sde-CHam_014*-RG.bam
Sde-CHam_077*-RG.bam
Sde-CMat_055*-RG.bam
Sde-CMat_061*-RG.bam 
```

Running merge script
```
bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus Sde
```
Next, need to run the fixing scripts. But these Scripts were made without a general prefix. So I copied the scripts here and modified both of them to fix to my prefix/bam pattern. 

```
cp ../scripts/merge_fixrg_array* .

nano merge_fixrg_array.bash
# example, I need to modify the Bam pattern
BAMPATTERN=*-merged-RG.bam
```

Running merge_fixrg_array.bash
```
bash merge_fixrg_array.bash mergebams_run1run2
```

These seemed to worked ok. So now moving back the merged.fixed.RG.bams back to mkBAM_config6 (1st run)
```
pwd
/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/
mv ../mergebams_run1run2/*bam* mkBAM_config6
```

I have to redo the coverage scripts.
```
cd mkBAM_config_6/
mv coverageMappedReads/ coverageMappedReads_noMergedBAM_deprecated
mv out_baitTrgtCVG/ out_baitTrgtCVG_noMergedBAM_deprecated
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/getBAITcvg.sbatch . /home/e1garcia/shotgun_PIRE/pire_probe_sets/03_Spratelloides_delicatulus/Spratelloides_Chosen_baits.singleLine.bed
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/mappedReadStats.sbatch . coverageMappedReads
```

Now, have to run the process_metadata r scripts again.

R scripts were not parsing the names of the merged files correctly. 

Thus,  I renamed the merged files so that they will have "merged-fixed" so I know these were merged and fixed, but also
put back the same naming scheme of the other files so the R scripts would parse the names correctly (added the same Lane, clmp, etc, format after the Spp_EraSite_Ind))


---

## Making a reference from CSSL Sde-CMat_087

Since we suspect issues with the RAD ref, one thing we thought we would check is to make a ref directly from one of the cssl individuals with better coverage.

pwd ` `

Made a copy of the repaired files in subidr `spades_CMat_087`
```
ls -ltrh spades_CMat_087
-rwxrwx--- 1 e1garcia users 449M Nov 14 17:10 Sde-CMat_087-SdC01087-L2-clmp-fp2-repr.R1.fq.gz
-rwxrwx--- 1 e1garcia users 541M Nov 14 17:11 Sde-CMat_087-SdC01087-L2-clmp-fp2-repr.R2.fq.gz
```
Assembled a ref from cssl using SPAdes in `SPAdes_Sde-CMat-A_decontam_R1R2_noIsolate`

I used Sgr genome size estimate for now.

Then, mapped all the data to the new ref in `mkBAM_csslRef` using default settings in config.6


### Running coverage scripts in mkBAM_csslRef

```
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/2nd_sequencing_run/mkBAM_csslRef
sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/mappedReadStats.sbatch . coverageMappedReads
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/getBAITcvg.sbatch . /home/e1garcia/shotgun_PIRE/pire_probe_sets/03_Spratelloides_delicatulus/Spratelloides_Chosen_baits.singleLine.bed
```

I encountered multiple problems with cssl:

1. I accidentally created links to the files from the 1run in the 2nd run. Thus I had to reran mkBAM_csslRef.

2. Some of the resulting *RG.bam files were empty. These were individuals that started with very low number of raw reads so it is probably not worth troubleshooting them.
Yes the problem is that empty files were braking the mappedReadStats.sbatch script so it would not compute stats for those files. It took some digging to find out that this was happening. 
To resolve this, I deleted the empty RG.bam files. 

3. When running the R scripts the colplot shows a substancially higher amount of reads mapping, suggesting RADseq genome not to be very good.
 Yet, the scatter plot with "Mean Depth of Coverage" shows lower depth for all pops, suggesting that the capture was not specific, i.e. we more reads mapping but not in the target regions

4. Unfortunately, the plots showing the depth in target regions are showing 0 depth. Now I think that the getBAITcvg.sbatch script didn't work probably because the name of contigs in the bed file are not the same than in the bam files. I will check this next

#### Making a new bed for the probe target regions compatible with CSSL Ref.

So the bed file I originally created for the baits contains the name of contigs from the RAD reference. 
When I created a new ref from cssl the contigs are not longer called/or are the same. 

Thus, I will to create a new bed for the cssl by:

1. Mapping the probe sequences to the cssl ref
2. Create a bed file from that bam
3. re-run the coverage scripts

***Setting up***
```
pwd
/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/mkBAM_csslRef/
# mkdir for making the Bed
mkdir mkBAM_mappingProbes_tomakeBED
# copy needed files from pwd to mkBAM_mappingProbes_tomakeBED
dDocentHPC_dev2.sbatch
config.6.cssl
reference.cssl.Sde-CMat_087.fasta
```

***Creating the fq files***

* mBAM needs R1 and R2 files (forward and reverse reads)

I copied the bait sequences, which have 3 tiles per region. For Sde, one from postion 0 to 80, another from 27 to 107, and the last from 54 to 133.  Example:
```
TGCAGGTGCTGGCTTCTTTTTCGTTGTAAAGAAGGACAAGTCCCTGAGACCCTGTATCGACTACCGAGGACTCAACAGTA
                           AAAGAAGGACAAGTCCCTGAGACCCTGTATCGACTACCGAGGACTCAACAGTATCACAGTGAAAAACAGGTACCCTCTTC
                                                     GTATCGACTACCGAGGACTCAACAGTATCACAGTGAAAAACAGGTACCCTCTTCCCTTATTGTCCTCGGCCTTTGACAAG
```

Given that the baits consist of 3 tiles which the middle is completely contained within the first and last tiles,
 I am running the first tile are the forward read and the last tile as the reverse read (and eliminating the middle)
```
ln ~/shotgun_PIRE/pire_probe_sets/03_Spratelloides_delicatulus/Bird_Final_Baits_GC_55-36_choosen_baits.fas mkBAM_mappingProbes_tomakeBED/
# this code prints the line matching "_0$" which is the first tile and the next line or the actual sequence.
awk '/_0$/{x=NR+1}(NR<=x){print}' Bird_Final_Baits_GC_55-36_choosen_baits.fas > Bird_Final_Baits_GC_55-36_choosen_baits.R1.fq
# this code prints the line matching "_53$" which is the last tile and the next line or the actual sequence.
awk '/_53$/{x=NR+1}(NR<=x){print}' Bird_Final_Baits_GC_55-36_choosen_baits.fas > Bird_Final_Baits_GC_55-36_choosen_baits.R2.fq
```

***Execute mkBAM***
```
sbatch dDocentHPC_dev2.sbatch mkBAM config.6.cssl
# after that was done, then
sbatch dDocentHPC_dev2.sbatch fltrBAM config.6.cssl
```

Then, I made the bed from the RAW bam (since we don't want to lose bait regions
```
bedtools bamtobed -i Bird_Final_Baits_GC_55-36_choosen_baits.cssl.Sde-CMat_087-RAW.bam > Sde_bait_csslRef.bed
```

Just in case, I will only keep the first 2 columns (name of contig, start pos , end pos)
```
cut -f1-3 Sde_bait_csslRef.bed > Sde_bait_csslRef_3columns.bed
```


***Running the probe coverage and R scripts again***
```
sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/getBAITcvg.sbatch . /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/spratelloides_delicatulus/mkBAM_csslRef/mkBAM_mappingProbes_tomakeBED/Sde_bait_csslRef_3columns.bed
```
Did the above for both 1st and 2nd run mkBAM_csslRef

***R scripts ran locally***
