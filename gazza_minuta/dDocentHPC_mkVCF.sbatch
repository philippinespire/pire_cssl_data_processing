#!/bin/bash -l

#SBATCH --job-name=mkVCF
#SBATCH -o mkBAM-fltrBAM-mkVCF-%j.out
#SBATCH --mail-user=rene.clark@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

enable_lmod
module load container_env ddocent

CONFIG=$1


#this will use freebayes to genotype the bam files and make a VCF, keep all sites (monomorphic)
crun bash ../../scripts/dDocentHPC/dDocentHPC.bash mkVCF $CONFIG
