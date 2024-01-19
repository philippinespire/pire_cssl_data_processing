# Gmi Data Processing Log

Log to track progress through capture bioinformatics pipeline for the Albatross and Contemporary *Gazza minuta* samples from Hamilo Cove and Basud River.

Information on data pre-processing & processing steps prior to merging `.bam` files can be found in the READMEs for the [1st sequencing run](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/gazza_minuta/1st_sequencing_run/README.md) and [2nd sequencing run](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/gazza_minuta/2nd_sequencing_run/README.md) directories.

---

## 10. Merge .bam files from two separate runs

Ran the merge script:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

bash ../scripts/runmerge_2runs_cssl_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta Gmi
```

Output: merged.bam files in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mergebams_run1run2`

Fixed read group information in merged `.bam` files:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

bash ../scripts/merge_fixrg_array.bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mmergebams_run1run2
```

Copied all `.bam` files (merged and unmerged) into one directory to be analyzed together:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

sbatch ../scripts/copyunmerged.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta mergebams_run1run2 mkBAMmerge
```

---

## 11. Generate mapping stats for capture targets

Ran `getBAITcvg.sbatch` to calculate the breadth and depth of coverage for the targeted bait regions:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

sbatch ../../scripts/getBAITcvg.sbatch . /home/e1garcia/shotgun_PIRE/pire_probe_sets/06_Gazza_minuta/Gazza_Chosen_baits.singleLine.bed
```

Ran `mappedReadStats.sbatch` to calculate the number of reads in each filtered `.bam` file, along with their mean length and depth:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

sbatch ../../../pire_fq_gz_processing/mappedReadStats.sbatch . coverageMappedReads
```

---

## 12. Run mapDamage

Ran mapDamage:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

#copying fasta file over
cp ../2nd_sequencing_run/mkBAM/reference.rad.RAW-10-10.fasta .

sbatch ../../scripts/runMAPDMG.2.sbatch "Gmi-*RG.bam" reference.rad.RAW-10-10.fasta
```

Cleaning up directories:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

mkdir mapDamage_output
mv results*-RG/ mapDamage_output

cd ..
mkdir mapdamageBAM

cd mapDamageBAM
mv ../mkBAMmerge/mapDamage_output/results*/*bam .
```

Renamed the rescaled `.bam` files so that dDocent will recognize them (made them end in `*-rescaled-RG.bam`).

---

## 13. Run mkVCF for merged BAM files

Copied and renamed reference fasta and `config.6.cssl` to `mapDamageBAM`:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mapDamageBAM

cp ../mkBAMmerge/referencerad.RAW-10-10.fasta ./reference.rad.RAW-10-10-rescaled.fasta
cp ../2nd_sequencing_run/mkBAM/config.6.cssl ./config.6.cssl.rescale
```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge

sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch fltrBAM config.5.cssl #Run filtering
sbatch ../../../dDocentHPC/dDocentHPC_dev2.sbatch mkVCF config.5.cssl #Make VCF files
```

Edited `config.6.cssl.rescale` so that the file names match and the settings are as desired:

```
----------mkREF: Settings for de novo assembly of the reference genome--------------------------------------------
PE             			Type of reads for assembly (PE, SE, OL, RPE)           PE=ddRAD & ezRAD pairedend, non-overlapping reads; SE=singleend reads; OL=ddRAD & ezRAD overlapping reads, miseq; RPE=oregonRAD, restriction site + random shear
rad               		Cutoff1 (integer)                                     
RAW-10-10-rescaled     		Cutoff2 (integer)
0.05    			rainbow merge -r <percentile> (decimal 0-1)            Percentile-based minimum number of seqs to assemble in a precluster
0.95   				rainbow merge -R <percentile> (decimal 0-1)            Percentile-based maximum number of seqs to assemble in a precluster
------------------------------------------------------------------------------------------------------------------
```

Ran mkVCF:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mapDamageBAM

sbatch ../../../dDocentHPC/dDocentHPC.sbatch mkVCF config.6.cssl.rescale
```

---

## 14. Filter VCF file

Made a filtering directory:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

mkdir /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF
```

Did not clone `fltrVCF` or `rad_haplotyper` since working out of Eric's directory.

Copied config file to directory:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF

cp ../../scripts/fltrVCF/config_files/config.fltr.ind.cssl .
```

Updated config with correct paths

```sh
fltrVCF Settings, run fltrVCF -h for description of settings
         # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07         # order to run filters in
        fltrVCF -c rad.RAW-10-10-rescale                                         # cutoffs, ie ref description
        fltrVCF -b ../mapDamageBAM                                               # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                 # path to fltrVCF R scripts
        fltrVCF -d ../mapDamageBAM/mapped.rad.RAW-10-10-rescaled.bed             # bed file used in genotyping
        fltrVCF -v ../mapDamageBAM/TotalRawSNPs.rad.RAW-10-10-rescaled.vcf       # vcf file to filter
        fltrVCF -g ../mapDamageBAM/reference.rad.RAW-10-10-rescaled.fasta        # reference genome
        fltrVCF -p ../mapDamageBAM/popmap.rad.RAW-10-10-rescaled                 # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                # path to rad_haplotyper script
        fltrVCF -o Gmi.A                                                         # prefix on output files, use to track settings
        fltrVCF -t 40                                                            # number of threads [1]
```

Did not adjust the filter settings (left them as the default).

Ran `fltrVCF.sbatch`:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl
```

---

## 15. Check for cryptic species

Made a `pop_structure` directory and copied filtered VCF file there.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

mkdir pop_structure
cd pop_structure

#copy final VCF file made from fltrVCF step to `pop_structure` directory
cp ../filterVCF/Gmi.A.rad.RAW-10-10-rescaled.Fltr07.18.vcf .

#There were too many "_" in sample ID names. This was rectified manually by editing the VCF using nano as there was issues with bcftools reading the VCF file.
```

There are too many "_" in sample ID names (some not all) for Plink. Fixed with following code:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load bcftools
bash
export SINGULARITY_BIND=/home/e1garcia

#created list of sample names
crun bcftools query -l Gmi.A.rad.RAW-10-10-rescaled.Fltr07.18.vcf > sample_names.txt

#modified sample_names.txt so that the only _ in the sample name was between the population and the individual number (ex: Gmi-ABas_018)

#renamed
crun bcftools reheader --samples sample_names.txt -o Gmi.A.rad.RAW-10-10-rescaled.Fltr07.18.renamed.vcf
rm Gmi.A.rad.RAW-10-10-rescaled.Fltr07.18.vcf

exit
```

Ran PCA using PLINK:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load container_env python3
bash
export SINGULARITY_BIND=/home/e1garcia

#VCF file has split chromosome, so running PCA from bed file
crun.python3 -p ~/.conda/envs/popgen plink --vcf Gmi.A.rad.RAW-10-10-rescaled.Fltr07.18.renamed.vcf --alow-extra-chr --make-bed --out PIRE.Gmi.Ham.rescaled.preHWE
crun.python3 -p ~/.conda/envs/popgen plink --pca --allow-extra-chr --bfile PIRE.Gmi.Ham.rescaled.preHWE --out PIRE.Gmi.Ham.rescaled.preHWE

exit
```

Made input files for ADMIXTURE with PLINK:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

bash
export SINGULARITY_BIND=/home/e1garcia

#bed and bim files already made (for PCA)
awk '{$1=0;print $0}' PIRE.Gmi.Ham.rescaled.preHWE.bim > PIRE.Gmi.Ham.rescaled.preHWE.bim.tmp
mv PIRE.Gmi.Ham.rescaled.preHWE.bim.tmp PIRE.Gmi.Ham.rescaled.preHWE.bim

exit
```

Ran ADMIXTURE (K = 1-5):

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure

module load container_env python3
bash
export SINGULARITY_BIND=/home/e1garcia

crun.python3 -p ~/.conda/envs/popgen admixture PIRE.Gmi.Ham.rescaled.preHWE.bed 1 --cv > PIRE.Gmi.Ham.rescaled.preHWE.log1.out
crun.python3 -p ~/.conda/envs/popgen admixture PIRE.Gmi.Ham.rescaled.preHWE.bed 2 --cv > PIRE.Gmi.Ham.rescaled.preHWE.log2.out
crun.python3 -p ~/.conda/envs/popgen admixture PIRE.Gmi.Ham.rescaled.preHWE.bed 3 --cv > PIRE.Gmi.Ham.rescaled.preHWE.log3.out
crun.python3 -p ~/.conda/envs/popgen admixture PIRE.Gmi.Ham.rescaled.preHWE.bed 4 --cv > PIRE.Gmi.Ham.rescaled.preHWE.log4.out
crun.python3 -p ~/.conda/envs/popgen admixture PIRE.Gmi.Ham.rescaled.preHWE.bed 5 --cv > PIRE.Gmi.Ham.rescaled.preHWE.log5.out

exit
```

Copied `*.eigenval`, `*.eigenvec`, & `*.Q` files to local computer. Ran pire_cssl_data_processing/scripts/popgen_analyses/pop_structure.R on local computer to visualize PCA & ADMIXTURE results (figures in `/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/pop_structure`).

---

## 16. Filter VCF file for HWE

PCA & ADMIXTURE showed cryptic structure. ABas & CBas (individuals from Basud River) were all assigned to one deme (deme "A"). ~50% of AHam & CBat (individuals from Hamilo Cove) were assigned to the same deme as ABas & CBas while the other ~50% clustered separately (identified as deme "B" for now).
  * Species IDs are unknown at this point, however Brendan recovered and blasted COI sequences for some individuals. Those recovered from Bas individuals hit against Gmi very confidently. CBat_008 (which belongs to the "B" deme) did not hit to Gmi, but instead hit against *Gazza spp Fiji* or *Gazza achlamys* with a higher % match (though not great). Thus, we are going to move forward deme "A" and continue to call it Gmi.

List of AHam & CBat individuals in deme "B" (39 in all):
  * **Albatross (11 total):** AHam_016, AHam_031, AHam_033, AHam_041, AHam_055,  AHam_060, AHam_065, AHam_078, AHam_079, AHam_083 & AHam_089
  * **Contemporary (28 total):** CBat_004, CBat_008, CBat_017, CBat_019, CBat_026, CBat_029, CBat_031, CBat_032, CBat_034, CBat_041, CBat_044, CBat_047, CBat_049, CBat_50, CBat_054, CBat_057, CBat_064, CBat_065, CBat_069, CBat_071,  CBat_073, CBat_079, CBat_084, CBat_087, CBat_088, CBat_090, CBat_091 & CBat_096

Modified popmap  file to reflect this new structure:

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF
cp ../mapDamageBAM/popmap.rad.RAW-10-10-rescaled  ./popmap.rad.RAW-10-10-rescaled.HWEsplit

#added -B to end of pop assignment (second column) to assign individual to deme B. deme A pop assignments remained unchanged
```

Made a copy of the `config.fltr.ind.cssl` file called `config.fltr.ind.cssl.HWE` with correct file paths and extensions.

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 18 17                                                                     # order to run filters in
        fltrVCF -c ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off                               # cutoffs, ie ref description
        fltrVCF -b ../mkBAMmerge                                                             # path to *.bam files
        fltrVCF -R ../../scripts/fltrVCF/scripts                                             # path to fltrVCF R scripts
        fltrVCF -d ../mkBAMmerge/mapped.rad.RAW-10-10.bed                                    # bed file used in genotyping
        fltrVCF -v Gmi.A.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr07.18.vcf           # vcf file to filter
        fltrVCF -g ../mkBAMmerge/reference.rad.RAW-10-10.fasta                               # reference genome
        fltrVCF -p popmap.rad.RAW-10-10.HWEsplit                                             # popmap file
        fltrVCF -w ../../scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                            # path to HWE filter script
        fltrVCF -r ../../scripts/rad_haplotyper/rad_haplotyper.pl                            # path to rad_haplotyper script
        fltrVCF -o Gmi.A                                                                     # prefix on output files, use to track settings
        fltrVCF -t 40                                                                        # number of threads [1]
```
Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge

sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.HWE
```

---
## Make a `VCF` file with monomorphic loci

Create a `mkVCF_monomorphic` dir to make an "all sites" VCF (with monomorphic loci included) and move necessary files over.


```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta

mkdir mkVCF_monomorphic

mv mkBAM/*bam* mkVCF_monomorphic
mv mkBAM/*fasta mkVCF_monomorphic
mv mkBAM/config.5.cssl mkVCF_monomorphic/config.5.cssl.monomorphic
```

Change the `config.5.cssl.monomorphic` file so that the last setting (monomorphic) is set to yes.

```
yes      freebayes    --report-monomorphic (no|yes)                      Report even loci which appear to be monomorphic, and report allconsidered alleles,
```

Genotype with [dDocentHPC_mkVCF.sbatch](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/dDocentHPC_mkVCF.sbatch).

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

sbatch ../../halichoeres_miniatus/mkVCF_monomorphic/dDocentHPC.sbatch config.5.cssl.monomorphic 
```

---

## Filter the VCF with monomorphic loci

First, set-up filtering for monomorphic sites only. Copy the `config.fltr.ind.cssl.mono` file over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

cp ../../scripts/config.fltr.ind.cssl.mono .
```

Update the `config.fltr.ind.cssl.mono` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made. **The settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file.**


```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 04 14 05 16 04 13 05 16 17                                                                                      # order to run filters in
        fltrVCF -c rad.RAW-10-10-RG                                                                                                      # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge                                         # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF                                                 # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge/mapped.rad.RAW-10-10.bed                # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/TotalRawSNPs.rad.RAW-10-10.vcf   # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/reference.rad.RAW-10-10.fasta    # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/popmap.rad.RAW-10-10.HWEsplit      # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                        # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                        # path to rad_haplotyper script
        fltrVCF -o Gmi.mono                                                                                                              # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                    # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for monomorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#settings for filters 04, 14, 05, 16, 13 & 17 should match the settings used when filtering the original VCF file
sbatch ../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.mono
```

Next, set-up filtering for polymorphic sites only. Make a `polymorphic_filter` directory in `mkVCF_monomorphic` and copy the `config.fltr.ind.cssl.poly` file over.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

mkdir polymorphic_filter
cd polymorphic_filter

cp ../../../scripts/config.fltr.ind.cssl.poly .
```

Update the `config.fltr.ind.cssl.poly` file with file paths and file extensions based on your species. The VCF path should point to the "all sites" VCF file you just made AND the HWEsplit popmap you made if you had any cryptic population structure. **The settings for all your filters should match the settings used when filtering the original VCF file.**

```
fltrVCF Settings, run fltrVCF -h for description of settings
        # Paths assume you are in `filterVCF dir` when running fltrVCF, change as necessary
        fltrVCF -f 01 02 03 04 14 07 05 16 15 06 11 09 10 04 13 05 16 07 18 17                                                             # order to run filters in
        fltrVCF -c rad.RAW-10-10-RG                                                                                                        # cutoffs, ie ref description
        fltrVCF -b /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic                                    # path to *.bam files
        fltrVCF -R /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/scripts                                           # path to fltrVCF R scripts
        fltrVCF -d /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge/mapped.rad.RAW-10-10.bed                  # bed file used in genotyping
        fltrVCF -v /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/TotalRawSNPs.rad.RAW-10-10.vcf     # vcf file to filter
        fltrVCF -g /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/reference.rad.RAW-10-10.fasta      # reference genome
        fltrVCF -p /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/filterVCF_merge/popmap.rad.RAW-10-10.HWEsplit        # popmap file
        fltrVCF -w /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/filter_hwe_by_pop_HPC.pl                          # path to HWE filter script
        fltrVCF -r /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/rad_haplotyper/rad_haplotyper.pl                          # path to rad_haplotyper script
        fltrVCF -o Gmi.poly                                                                                                                # prefix on output files, use to track settings
        fltrVCF -t 40                                                                                                                      # number of threads [1]
```

Run [`fltrVCF.sbatch`](https://github.com/philippinespire/pire_cssl_data_processing/blob/main/scripts/fltrVCF.sbatch) for polymorphic sites.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/polymorphic_filter

#before running, make sure the config file is updated with file paths and file extensions based on your species
#VCF file should be the VCF file made after the "make monomorphic VCF" step
#popmap file should be the one that accounts for any cryptic structure, if it exists (*HWEsplit extension)
#settings should match the settings used when filtering the original VCF file
sbatch ../../../scripts/fltrVCF.sbatch config.fltr.ind.cssl.poly 
```


## Merge monomorphic & polymorphic VCF files

Check the *filtered* monomorphic & polymorphic VCF files to make sure that filtering removed the same individuals. If not, remove the necessary individuals from the relevant files. *Your monomorphic and polymorphic VCFs should have the EXACT same individuals present. If not, merging will not work!*

Next, sort each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load vcftools

vcftools --vcf Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.vcf --remove indv_missing.txt --recode --recode-INFO-all --out Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.vcf
vcf-sort Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.vcf > Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf

vcftools --vcf Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.vcf --remove ../indv_missing.txt --recode --recode-INFO-all --out Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.vcf
vcf-sort Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.vcf > Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf
```

Zip each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load samtools/1.9

bgzip -c Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf > Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz
bgzip -c Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf > Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf.gz

```

Index each VCF file.

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load samtools/1.9

tabix Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz
tabix Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf.gz
```

Had to re-sort and reheader poly VCF file

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic/polymorphic_filter

crun bcftools reheader -h header_poly.txt -o Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.vcf
bgzip -c Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf > Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf.gz

bash
export SINGULARITY_BIND=/home/e1garcia
crun bcftools concat --allow-overlaps Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf.gz -O z -o Gmi.all.recode.sorted.vcf.gz

tabix Gmi.all.recode.nomissing.sorted.vcf.gz

exit
```

```sh
cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkVCF_monomorphic

module load container_env bcftools
module load samtools/1.9

bash
crun bcftools concat --allow-overlaps Gmi.mono.rad.RAW-10-10-RG.Fltr17.11.recode.nomissing.sorted.vcf.gz Gmi.poly.rad.RAW-10-10-RG.Fltr17.20.recode.nomissing.sorted.FIXING.vcf.gz -O z -o Gmi.all.recode.sorted.vcf.gz
tabix Gmi.all.recode.nomissing.sorted.vcf.gz
exit
```
