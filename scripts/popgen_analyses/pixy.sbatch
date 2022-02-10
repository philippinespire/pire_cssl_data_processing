#!/bin/bash -l

#SBATCH --job-name=pixy
#SBATCH -o pixy-%j.out
#SBATCH -p main
#SBATCH -c 4
##SBATCH --time=96:00:00
#SBATCH --mail-user=rene.clark@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

#to run use the following command:
#sbatch pixy.sbatch

enable_lmod
module load anaconda

conda activate popgen

pixy --stats pi fst --vcf lle.all.recode.nomissing.sorted.vcf.gz --populations allsites_popfile.txt --window_size 1000 --n_cores 4

#allsites_popfile.txt is the same structure as popmap file (just renamed and without any individuals that were removed during VCF filtering)
