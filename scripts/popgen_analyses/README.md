# Code for PopGen Analyses with CSSL Data

This directory has useful scripts & code to run any "standard" population genetic analyses with VCF files created from CSSL data. README has instructions for installing/loading any required programs on Wahab. Directory contains stand-alone R & slurm scripts for downstream visualization/analyses.

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
conda config --add chanels conda-forge

#install plink
conda install -c bioconda plink

conda deactivate
```

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
