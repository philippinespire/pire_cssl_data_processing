#!/bin/bash -l

#SBATCH --job-name=fltrVCF
#SBATCH -o fltrVCF-%j.out
#SBATCH -p main
#SBATCH -c 40
##SBATCH --time=96:00:00

#to run use the following command:
#sbatch fltrVCF.sbatch config.fltr.ind

enable_lmod
module load container_env ddocent/2.7.8
module load container_env vcflib
export SINGULARITY_BIND=/home/e1garcia
export PARALLEL_SHELL=/bin/bash

#module load ddocent
#module load perl/5.22.0
#module load vcftools/0.1.15
#module load rad_haplotyper/1.1.5
#module load parallel
#module load vcflib/1.0
#module load samtools
#module load R/gcc7/3.5.3

crun bash /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/fltrVCF/fltrVCF.bash -s $1
