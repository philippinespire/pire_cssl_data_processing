PCA
================

Code for calculating eigenvalues & eigenvectors with the program PLINK. Instructions for installing PLINK can be found in `/popgen_analyses/README.md`.

```bash
#NOTE: probably best to grab an interactive node for this (don't run on log-in node).

module load anaconda

conda activate popgen

plink --vcf <VCF_FILE> --allow-extra-chr --pca <PIRE.SPECIES.LOC>

conda deactivate
```

Copy `*.eigenvec` & `*.eigenval` files to local computer and read into R for downstream analysis/visualization (`popgen_analyses/pop_structure.R`).
