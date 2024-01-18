#!/bin/bash -l

#SBATCH --job-name=mpdmg
#SBATCH -o mapDamage-%j.out
#SBATCH -p main
#SBATCH -c 40
#SBATCH --exclusive

enable_lmod
module load container_env mapdamage2
module load parallel

export SINGULARITY_BIND=/home/e1garcia/shotgun_PIRE/pire_cssl_data_processing

PATTERN=$1
REF=$2

echo FILES=$PATTERN
echo REF=$REF

ls $PATTERN | parallel --no-notice -kj 40 "crun mapDamage -i {} -r $REF -l 150 --rescale --merge-reference-sequences"
