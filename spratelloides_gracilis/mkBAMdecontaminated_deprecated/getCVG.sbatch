#!/bin/bash -l

#SBATCH --job-name=Samtools
#SBATCH -o mappedReadStats_-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=40

enable_lmod
module load samtools
module load parallel

export SINGULARITY_BIND="/home/cbird,/home/e1garcia/"

BAMDIR=$1
OUTDIR=$2

if [[ -z "$3" ]]; then
	BAMPATTERN="-RG.bam"
else
	BAMPATTERN=$3
fi

mkdir $OUTDIR

ls $BAMDIR/*$BAMPATTERN | \
	sed -e 's/^.*\///' \
	    -e 's/\.bam//' | \
	parallel --no-notice \
		 -j 32 \
		 "samtools coverage $BAMDIR/{}.bam > $OUTDIR/{}.cvg"

echo `date`
echo $BAMDIR
echo $OUTDIR
echo $BAMPATTERN
