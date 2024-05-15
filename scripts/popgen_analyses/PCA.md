PCA
================

Code for calculating eigenvalues & eigenvectors with the program PLINK. Instructions for installing PLINK can be found in `/popgen_analyses/README.md`.

```bash
#NOTE: probably best to grab an interactive node for this (don't run on log-in node).

module load container_env python3

crun.python3 -p ~/.conda/envs/popgen plink --vcf <VCF_FILE> --allow-extra-chr --pca var-wts --out <PIRE.SPECIES.LOC>
```

Copy `*.eigenvec` & `*.eigenval` files to local computer and read into R for downstream analysis/visualization (`popgen_analyses/pop_structure.R`).
