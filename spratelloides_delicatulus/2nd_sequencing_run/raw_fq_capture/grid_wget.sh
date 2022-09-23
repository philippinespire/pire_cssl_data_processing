#!/bin/bash -l

#SBATCH --job-name=sdeWget
#SBATCH -o sdeWget-%j.out
#SBATCH --time=00:00:00
#SBATCH --exclusive
#SBATCH --ntasks=40
#SBATCH -p main

module load parallel

cat missing_files_sde | parallel --no-notice -kj40 wget https://gridftp.tamucc.edu/genomics/20220912_PIRE-Sde-capture2/{}
