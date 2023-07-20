#!/bin/bash

#SBATCH --job-name=insertCal
#SBATCH --output=insertCal-%j.out
#SBATCH -c 40
##SBATCH --mail-user=<your email>
##SBATCH --mail-type=begin
##SBATCH --mail-type=END

enable_lmod
module load parallel
module load samtools
export SINGULARITY_BIND=/home/e1garcia

regex=$1
ls $regex | parallel --no-notice -kj40 "samtools view {} | cut -f9 | sed 's/-//' | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' > {}.insertSize"

cat *.insertSize | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' > all_insertSize

echo "Average insert size for $regex is: $(cat all_insertsize)"
