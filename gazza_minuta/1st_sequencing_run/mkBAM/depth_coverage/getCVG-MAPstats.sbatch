#!/bin/bash -l

#SBATCH --job-name=cvg-map_ReadStats
#SBATCH -o cvg-map_ReadStats-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=32

enable_lmod
module load samtools
module load parallel

export SINGULARITY_BIND="/home/cbird,/home/e1garcia/,/home/r3clark/"

BAMDIR=$1
OUTDIR=$2
SPECIES=$3

if [[ -z "$4" ]]; then
	BAMPATTERN="-RG.bam"
else
	BAMPATTERN=$4
fi

if [[ $1 == "." ]]; then
	BAMDIR=$PWD
else
	BAMDIR=$1
fi

if [[ $2 == "." ]]; then
        OUTDIR=$PWD
else
        OUTDIR=$1
fi

echo `date`
echo -e "\nBAMDIR=$BAMDIR"
echo "OUTDIR=$OUTDIR"
echo "BAMPATTERN=$BAMPATTERN"
echo "SPECIES=$SPECIES"

mkdir -p $OUTDIR
BAMPATH=$(echo $1 | sed "s/\/$//")

echo -e "\nRunning samtools coverage and stats"
ls $BAMDIR/*$BAMPATTERN | \
	sed -e 's/^.*\///' \
	    -e 's/\.bam//' | \
	parallel --no-notice \
		 -kj 32 \
		 "samtools coverage $BAMDIR/{}.bam > $OUTDIR/{}.cvg && \
		  samtools stats $BAMDIR/{}.bam > $OUTDIR/{}.stats"

# Functions
avgBP () {
	BAMFILE=$1
        samtools view $BAMFILE | \
                cut -f10 | \
                awk '{ print length }' | \
                awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' 
}
export -f avgBP

avgDP () {
	# return mean depth for positions with coverage
	BAMFILE=$1
	samtools depth -s $BAMFILE | \
		cut -f3 | \
		awk '{ sum += $1 } END { if (NR > 0) print sum / NR }'
}
export -f avgDP

posWWOCVG () {
	# return num pos with and without coverage
	# 3 cols
	# num_pos num_pos_w_cvg 
	BAMFILE=$1
	samtools coverage $BAMFILE | \
		cut -f3,5 | \
		awk 'BEGIN { OFS = "\t" } {for (i=1;i<=NF;i++) a[i]+=$i} END{for (i=1;i<=NF;i++) printf a[i] OFS; printf "\n"}' 

}
export -f posWWOCVG

echo "Calculating summary stats"
ls $BAMPATH/*$BAMPATTERN | \
        parallel --no-notice -j 20 "echo {} && samtools view -c {} && avgBP {} && avgDP {} && posWWOCVG {}" | \
        paste - - - - - | \
        awk 'BEGIN { OFS = "\t" } NR>=1 {$7 = $4 * $6 / $5} 1' | \
        awk 'BEGIN { OFS = "\t" } NR>=1 {$8 = 100 * $6 / $5} 1' > $OUTDIR/out_${SPECIES}_ReadStats.tsv

echo -e "\nSummary Completed. Out file=$OUTDIR/out_${SPECIES}_ReadStats.tsv" 

# Adding a header
# filename numreads meanreadlength meandepth_wcvg numpos numpos_wcvg meandepth pctpos_wcvg
sed -i '1s/^/filename\tnumreads\tmeanreadlength\tmeandepth_wcvg\tnumpos\tnumpos_wcvg\tmeandepth\tpctpos_wcvg\n/' $OUTDIR/out_${SPECIES}_ReadStats.tsv

# output
# filename numreads meanreadlength meandepth_wcvg numpos numpos_wcvg meandepth pctpos_wcvg

echo -e "\nProcessed files\n$(ls $BAMPATH/*$BAMPATTERN)"

