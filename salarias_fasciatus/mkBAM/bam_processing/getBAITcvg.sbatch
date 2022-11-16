#!/bin/bash -l

#SBATCH --job-name=bedtools
#SBATCH -o bedtoolstats-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=40

enable_lmod
module load bedtools2/2.27.1
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

mkdir -p $OUTDIR

ls $BAMDIR/*$BAMPATTERN | \
        sed -e 's/^.*\///' \
            -e 's/\.bam//' | \
        parallel --no-notice \
                 -kj 32 \
		"bedtools coverage -hist -a $BED -b $BAMDIR/{}.bam > $OUTDIR/{}.baitCVG.txt"

ls $OUTDIR/*baitCVG.txt | \
	sed -e 's/^.*\///' \
            -e 's/\.baitCVG\.txt//' | \
	parallel --no-notice \
		-kj32 \
		"grep 'NODE' $OUTDIR/{}.baitCVG.txt > $OUTDIR/{}.baitCVG.hist.txt" 

ls $OUTDIR/*baitCVG.txt | \
        sed -e 's/^.*\///' \
            -e 's/\.baitCVG\.txt//' | \
        parallel --no-notice \
                -kj32 \
                "grep 'all' $OUTDIR/{}.baitCVG.txt > $OUTDIR/{}.baitCVG.hist.all.txt" 

rm $OUTDIR/*.baitCVG.txt

echo `date`
echo "BAMDIR $BAMDIR"
echo "BAMPATTERN $BAMPATTERN"
echo "BED $BED"
echo "OUTDIR $OUTDIR"

