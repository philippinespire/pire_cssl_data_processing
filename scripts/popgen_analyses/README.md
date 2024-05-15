# Code for PopGen Analyses with CSSL Data

This directory has useful scripts & code to run any "standard" population genetic analyses with VCF files created from CSSL data. README has instructions for installing/loading any required programs on Wahab. Directory contains stand-alone R & slurm scripts for downstream visualization/analyses.

### Scripts:

* **ADMIXTURE.md:** Code for running ADMIXTURE on Wahab. Instructions for installing ADMIXTURE are below.
* **diversity.R:** Script for calculating Ho & He, either on Wahab or local computer.
* **fst.R:** Script for visualizing fst results from pixy, and calculating fst (pairwise & per-locus) with the hierfstat R package.
* **LD_pruning.md:** Code for removing loci in linkage disequilibrium with PLINK. Instructions for installing PLINK are below.
* **pi.R:** Script for visualizing, averaging & bootstrapping pi from pixy.
* **PCA.md:** Code for calculating eigenvectors & eigenvalues with PLINK. Instructions for installing PLINK are below.
* **pixy.md:** Code for running pixy to calculate pi & Fst on Wahab. Instructions for installing pixy are below
* **pixy.sbatch:** Sbatch script for running pixy on Wahab.
* **pop_structure.R:** Script for visualizing PCA & ADMIXTURE results. 

---

## Installing PLINK

Necessary to run PCA (with PLINK). Also useful for easily filtering VCFs and creating bed/bim files.

```sh
#to create conda environment that will contain popgen programs --> only need to do this ONCE
module load container_env python3

crun.python3 -c -s -p ~/.conda/envs/popgen
crun.python3 -p ~/.conda/envs/popgen mamba

#install plink
install -c bioconda -c conda-forge plink
```

---

## Installing ADMIXTURE

Necessary to run ADMIXTURE to visualize population structure (best supported # of population clusters).

```sh
#assumes popgen conda environment has already been created
module load container_env python3

crun.python3 -p ~/.conda/envs/popgen mamba

#install admixture
install -c bioconda admixture
```

---

## Installing pixy

Necessary to run pixy to calculate pi.

```sh
#assumes popgen conda environment has already been created
module load container_env python3

crun.python3 -p ~/.conda/envs/popgen mamba

#install pixy
install -c conda-forge pixy
install -c bioconda htslib
```
