# Code for PopGen Analyses with CSSL Data

This directory has useful scripts & code to run any "standard" population genetic analyses with VCF files created from CSSL data. README has instructions for installing/loading any required programs on Wahab. Directory contains stand-alone R & slurm scripts for downstream visualization/analyses.

### Scripts:

* **ADMIXTURE.md:** Code for running ADMIXTURE on Wahab. Instructions for installing ADMIXTURE are below.
* **diversity.R:** Script for calculating Ho, He & Fst (pairwise & per locus), either on Wahab or local computer.
* **LD_pruning.md:** Code for removing loci in linkage disequilibrium with PLINK. Instructions for installing PLINK are below.
* **PCA.md:** Code for calculating eigenvectors & eigenvalues with PLINK. Instructions for installing PLINK are below.
* **pixy.md:** Code for running pixy to calculate pi & Fst on Wahab. Instructions for installing pixy are below
* **pixy.sbatch:** Sbatch script for running pixy on Wahab.
* **pop_structure.R:** Script for visualizing PCA & ADMIXTURE results. 

---

## Installing PLINK

Necessary to run PCA (with PLINK). Also useful for easily filtering VCFs and creating bed/bim files.

```
#to create conda environment that will contain popgen programs --> only need to do this ONCE
module load container_env/0.1
module load conda/3
module load anaconda

conda create -n popgen
conda activate popgen
conda config --add channels conda-forge

#install plink
conda install -c bioconda plink

conda deactivate
```

---

## Installing ADMIXTURE

Necessary to run ADMIXTURE to visualize population structure (best supported # of population clusters).

```
#assumes popgen conda environment has already been created
module load anaconda
conda activate popgen

#install admixture
conda install -c bioconda admixture

conda deactivate
```

---

## Installing pixy

Necessary to run pixy to calculate pi.

```
#assumes popgen conda environment has already been created
module load container_env/0.1
module load conda/3
module load anaconda
conda activate popgen

#install pixy
conda install -c conda-forge pixy
conda install -c bioconda htslib

conda deactivate
```
