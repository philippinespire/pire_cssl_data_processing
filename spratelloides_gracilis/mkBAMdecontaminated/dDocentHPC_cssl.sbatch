#!/bin/bash -l

#SBATCH --job-name=mkVCF
#SBATCH -o mkVCF-%j.out
#SBATCH -p main
#SBATCH -c 40

enable_lmod
module load container_env ddocent
export SINGULARITY_BIND=/home/e1garcia  

CONFIG=$1

#crun bash dDocentHPC.bash mkBAM $CONFIG

#this will use dDocent fltrBAM to filter the BAM files
#crun bash dDocentHPC.bash fltrBAM $CONFIG

#this will use freebayes to genotype the bam files and make a VCF
crun bash dDocentHPC.bash mkVCF $CONFIG

