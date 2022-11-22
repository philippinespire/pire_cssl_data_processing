#!/bin/bash -l

#SBATCH --job-name=fltrBAM
#SBATCH -o fltrBAM-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=40

enable_lmod
module load container_env bwa-mem2
export SINGULARITY_BIND=/home/e1garcia

bamDIR=$1
# only pick one
crun ./fltrBAMwgs.bash $bamDIR
