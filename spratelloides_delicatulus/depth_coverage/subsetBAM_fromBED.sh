#!/bin/bash -l

#SBATCH --job-name=subBAM
#SBATCH -o subBAM_fromBED-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=40

#This script subsets a full BAM file to only the contigs in a given BED file.

# We used this script to subset BAM for only the contigs used for probe development and later calculate coverage specific to the probe region.
# To make the bed
#cat p*ta  | grep '^>' | sed 's/_/\t/' | cut -f1 | sort | uniq | sed 's/:/_/g' > contigs_forProbes_Sde
#awk '{print $1"\t0\t1000000000"}' contigs_forProbes_Sde > contigs_forProbes_Sde.bed


enable_lmod
module load samtools
module load parallel

export SINGULARITY_BIND="/home/cbird,/home/e1garcia/"

BAMDIR=$1
OUTDIR=$2
BED=$3

if [[ -z "$4" ]]; then
	BAMPATTERN="-RG.bam"
else
	BAMPATTERN=$4
fi

BEDNAME=$(ls $3 | sed 's/\.bed//')

mkdir -p $OUTDIR

ls $BAMDIR/*$BAMPATTERN | \
	sed -e 's/^.*\///' \
	    -e 's/-RG\.bam//' | \
	parallel --no-notice \
		 -j 32 \
		"samtools view -b -L $BED $BAMDIR/{}$BAMPATTERN > $OUTDIR/{}-$BEDNAME$BAMPATTERN"

echo `date`
echo $BAMDIR
echo $OUTDIR
echo $BAMPATTERN
