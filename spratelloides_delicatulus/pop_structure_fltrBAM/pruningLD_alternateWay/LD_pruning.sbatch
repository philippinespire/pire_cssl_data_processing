#!/bin/bash -l

#SBATCH --job-name=LDpru
#SBATCH -o pruningLD-%j.out
#SBATCH -p main
#SBATCH -c 40

module load anaconda
module load vcftools

conda activate popgen

VCF_FILE=$1

#vcftools --vcf $VCF_FILE --plink --out myplink

#plink --noweb --file myplink --indep-pairwise 50 5 0.2
plink --noweb --file myplink --indep 50 5 2


#plink --vcf $VCF_FILE --allow-extra-chr --const-fid --set-missing-var-ids @:# --indep-pairwise 50 10 0.5 --out Sde.A.ssl.Sde-CMat_061.Fltr07.18.
#awk -F: '{print $1, $2}' LD.prune.in > LD.prune.in.2
#vcftools --vcf $VCF_FILE --positions LD.prune.in.2 --recode --recode-INFO-all --out noLD

#plink --vcf Sde.A.ssl.Sde-CMat_061.Fltr07.18.vcf --allow-extra-chr --const-fid --set-missing-var-ids @:# --make-bed --out LD

#plink --vcf Sde.A.ssl.Sde-CMat_061.Fltr07.18.vcf --allow-extra-chr --const-fid --make-bed --out LD


# i was still getting the split chromosome error so tried straight in command line
#plink --bfile LD --allow-extra-chr --make-bed --out LD.sorted
#PIRE.Sde.allpops.preHWE.sorted

conda deactivate

