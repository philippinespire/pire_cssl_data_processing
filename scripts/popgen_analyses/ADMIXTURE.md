ADMIXTURE
================

Code for running ADMIXTURE to assess population structure. Requires input (bim & bed files) created with PLINK. Instructions for installing PLINK & ADMIXTURE can be found in `/popgen_analyses/README.md`.

```bash
#NOTE: probably best to grab an interactive node for this (don't run on log-in node).

module load container_env python3

crun.python3 -p ~/.conda/envs/popgen plink --vcf <VCF_FILE> --allow-extra-chr --make-bed --out <PIRE.SPECIES.LOC>

awk '{$1=0;print $0}' PIRE.SPECIES.LOC.bim > PIRE.SPECIES.LOC.bim.tmp
mv PIRE.SPECIES.LOC.bim.tmp PIRE.SPECIES.LOC.bim

crun.python3 -p ~/.conda/envs/popgen admixture PIRE.SPECIES.LOC.bed 1 --cv > PIRE.SPECIES.LOC.log1.out #run from 1-5
```

Copy `*.Q` files to local computer. Read into R for visualization (`popgen_analyses/pop_structure.R`).
