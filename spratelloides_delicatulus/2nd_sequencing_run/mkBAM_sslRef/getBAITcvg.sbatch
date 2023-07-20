#!/bin/bash -l

#SBATCH --job-name=bedtools
#SBATCH -o bedtoolstats-%j.out
#SBATCH --time=00:00:00
#SBATCH --cpus-per-task=32
#SBATCH -p himem


# "getBAITcvg.sbatch" uses "bedtools coverage -hist" to calculates the breath and depth of coverage from the targeted Bait regions only (as determined by a bed file).
# It compares each region provided by the bed file to the aligments in bam files.
# the output "hist.txt" and  "hist.all.txt" provide stats for each region and a summary for all regions, respectively (per bam file) 
# the hist.all.txt can be plotted with the baitCVG.R script
# contact: Eric Garcia e1garcia@odu.edu

# Source:
# bedtool coverage doc available at https://bedtools.readthedocs.io/en/latest/content/tools/coverage.html
# This script is based on the implementation of bedtools coverage -hist to calculate stats from targetted regions from https://gettinggeneticsdone.blogspot.com/2014/03/visualize-coverage-exome-targeted-ngs-bedtools.html

# To execute:
# provide (1) the directory to the BAM files, (2) where you would like the output to be written and (3) the bed file (include full path for bed file)
# the script assumes an "-RG.bam" extension for bam files. If your bam files have diff. suffix, please provide this as the 4th argument when executing script
# example:
# sbatch getBAITcvg.sbatch ../mkBAM . ./Sgr_Baits_chosen.bed


enable_lmod
#module load bedtools2/2.27.1
module load container_env bedtools
module load parallel

export SINGULARITY_BIND="/home/cbird,/home/e1garcia/"

BAMDIR=$1       # Where the BAM files are
BED=$2		# Path and name of bed file
#OUTDIR=$3 # Where the output will be written

if [[ -z "$3" ]]; then
        OUTDIR=$BAMDIR/out_baitTrgtCVG
else
        OUTDIR=$3/out_baitTrgtCVG
fi

if [[ -z "$4" ]]; then
        BAMPATTERN="-RG.bam"
else
        BAMPATTERN=$4
fi


#Make outdir
#OUTDIR=$OUTPATH/out_baitCVG
mkdir -p $OUTDIR

ls $BAMDIR/*$BAMPATTERN | \
        sed -e 's/^.*\///' \
            -e 's/\.bam//' | \
        parallel --no-notice \
                 -kj 32 \
		"crun.bedtools bedtools coverage -hist -a $BED -b $BAMDIR/{}.bam > $OUTDIR/{}.baitCVG.tsv"

ls $OUTDIR/*baitCVG.tsv | \
	sed -e 's/^.*\///' \
            -e 's/\.baitCVG\.tsv//' | \
	parallel --no-notice \
		-kj32 \
		"grep -v 'all' $OUTDIR/{}.baitCVG.tsv > $OUTDIR/{}.baitCVG.hist.tsv" 

ls $OUTDIR/*baitCVG.tsv | \
        sed -e 's/^.*\///' \
            -e 's/\.baitCVG\.tsv//' | \
        parallel --no-notice \
                -kj32 \
                "grep 'all' $OUTDIR/{}.baitCVG.tsv > $OUTDIR/{}.baitCVG.hist.all.tsv" 

rm $OUTDIR/*.baitCVG.tsv

echo "SLURM Job ID: ${SLURM_JOB_ID}" > $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
echo `date` >> $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
echo "Script executed from: ${PWD}" >> $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
echo "BAMDIR $BAMDIR" >> $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
echo "BAMPATTERN $BAMPATTERN" >> $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
echo "BED $BED" >> $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
echo "OUTDIR $OUTDIR" >> $OUTDIR/getBAITcvg-${SLURM_JOB_ID}.log
