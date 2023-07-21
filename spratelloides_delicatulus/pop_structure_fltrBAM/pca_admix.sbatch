#!/bin/bash -l

#SBATCH --job-name=LDpru
#SBATCH -o pruningLD-%j.out
#SBATCH -p main
#SBATCH -c 40

module load anaconda
module load vcftools

conda activate popgen

VCF_FILE=$1

# make bed and other plink files
#plink --vcf $VCF_FILE --allow-extra-chr --make-bed --out PIRE.Sde.allpops.preHWE

# compute pca
#plink --pca --allow-extra-chr --bfile PIRE.Sde.allpops.preHWE --out PIRE.Sde.allpops.preHWE

# generate output for admixture; bed and bim files already made (for PCA)
#awk '{$1=0;print $0}' PIRE.Sde.allpops.preHWE.bim > PIRE.Sde.allpops.preHWE.bim.tmp
#mv PIRE.Sde.allpops.preHWE.bim.tmp PIRE.Sde.allpops.preHWE.bim

# run admixture with different Ks (number of pops). 
#If you might expect 2 pops (alb and contem from 1 locality), I would run 1-5 Ks.
#If you might expect many (alb/contem from many locs), I would perhaps run twice as many as you expect. 
# For example, Sde I have alb/contem from 4 localities. K16 will be my upper limit

admixture PIRE.Sde.allpops.preHWE.bed 2 --cv > PIRE.Sde.allpops.preHWE.log2.out
#admixture PIRE.Sde.allpops.preHWE.bed 5 --cv > PIRE.Sde.allpops.preHWE.log5.out 
#admixture PIRE.Sde.allpops.preHWE.bed 6 --cv > PIRE.Sde.allpops.preHWE.log6.out 
#admixture PIRE.Sde.allpops.preHWE.bed 7 --cv > PIRE.Sde.allpops.preHWE.log7.out 
#admixture PIRE.Sde.allpops.preHWE.bed 9 --cv > PIRE.Sde.allpops.preHWE.log9.out 
#admixture PIRE.Sde.allpops.preHWE.bed 10 --cv > PIRE.Sde.allpops.preHWE.log10.out 
#admixture PIRE.Sde.allpops.preHWE.bed 11 --cv > PIRE.Sde.allpops.preHWE.log11.out 
#admixture PIRE.Sde.allpops.preHWE.bed 13 --cv > PIRE.Sde.allpops.preHWE.log13.out 
admixture PIRE.Sde.allpops.preHWE.bed 14 --cv > PIRE.Sde.allpops.preHWE.log14.out 
#admixture PIRE.Sde.allpops.preHWE.bed 15 --cv > PIRE.Sde.allpops.preHWE.log15.out 


#plink --vcf $VCF_FILE --allow-extra-chr --const-fid --set-missing-var-ids @:# --indep-pairwise 50 10 0.5 --out Sde.A.ssl.Sde-CMat_061.Fltr07.18.
#awk -F: '{print $1, $2}' LD.prune.in > LD.prune.in.2
#vcftools --vcf $VCF_FILE --positions LD.prune.in.2 --recode --recode-INFO-all --out noLD

#plink --vcf Sde.A.ssl.Sde-CMat_061.Fltr07.18.vcf --allow-extra-chr --const-fid --set-missing-var-ids @:# --make-bed --out LD

#plink --vcf Sde.A.ssl.Sde-CMat_061.Fltr07.18.vcf --allow-extra-chr --const-fid --make-bed --out LD


# i was still getting the split chromosome error so tried straight in command line
#plink --bfile LD --allow-extra-chr --make-bed --out LD.sorted
#PIRE.Sde.allpops.preHWE.sorted

conda deactivate

