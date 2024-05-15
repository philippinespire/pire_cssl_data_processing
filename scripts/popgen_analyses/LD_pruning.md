LD Pruning
================

Code for removing loci in linkage disequilibrium with the program PLINK. Instructions for installing PLINK can be found in `/popgen_analyses/README.md`.

**NOTE:** This is very coarse LD pruning. It simply calculates LD between pairs of SNPs within a certain window and removes one of the pair if the R2 is greater than 0.5. Useful when reference genome/chromosomal arrangements aren't available.

```bash
#NOTE: probably best to grab an interactive node for this (don't run on log-in node).

module load container_env python3

crun.python3 -p ~/.conda/envs/popgen plink --vcf <VCF_FILE> --allow-extra-chr --set-missing-var-ids @:# --indep-pairwise 50 10 0.5 --out LD
awk -F: '{print $1, $2}' LD.prune.in > LD.prune.in.2

module unload python3
module load bcftools
crun vcftools --vcf <VCF_FILE> --positions LD.prune.in.2 --recode --recode-INFO-all --out noLD
```
