#!/bin/bash -l

#SBATCH --job-name=Fst
#SBATCH -o Fst-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=40
#SBATCH --exclusive=user


module load container_env ddocent/2.9.4   
crun.vcftools vcftools --vcf Sde.A.ssl.Sde-CMat_061.Fltr07.18.vcf --weir-fst-pop pop1.txt ABul.txt --weir-fst-pop pop1.txt AMat.txt --weir-fst-pop pop1.txt ATum.txt --weir-fst-pop pop1.txt CHam.txt --weir-fst-pop pop1.txt CJol.txt --weir-fst-pop pop1.txt CMat.txt --weir-fst-pop pop1.txt CTum.txt --weir-fst-pop pop1.txt CVal.txt --out Sde_fst_fp2_min140

