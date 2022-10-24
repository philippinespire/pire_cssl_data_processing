#!/bin/bash

#SBATCH --job-name=cat-dfLanes
#SBATCH -o cat-dfLanes-%j.out
#SBATCH -p main
#SBATCH -c 40

# contact: Dr. Eric Garcia e1garcia@odu.edu
# This script concatenates files from the same individual but from different sequencing lanes (L1, L2, L3, L4, etc)
# Expects the following file name format "SdA0100208H_CKDL220019623-1A_H7TTHDSX5_L3_1.fq.gz"

# To execute place this scrpt in the same dir as with the files to be concatenated and execute specifying the desired out directory as the first argument
# example: "sbatch concat_diff_lanes.sh concatenated_files"

module load parallel

date

if [[ -z "$1" ]]; then
        echo "\nNo out directory specified. Outdir= $PWD"
	OUTDIR=$PWD
        exit 1
else
	echo "Outdir=$1"
        OUTDIR=$1
fi

# Make dir for new files
mkdir -p $OUTDIR

# Print what is happening
ls *gz | sed 's/_L.*//' | uniq | parallel --no-notice -kj20 "echo concatenating {}*1.fq.gz into $OUTDIR/{}_LA_1.fq.gz"
ls *gz | sed 's/_L.*//' | uniq | parallel --no-notice -kj20 "echo concatenating {}*2.fq.gz into $OUTDIR/{}_LA_1.fq.gz"

# Concatenate files
ls *gz | sed 's/_L.*//' | uniq | parallel --no-notice -kj40 "cat {}*1.fq.gz > $OUTDIR/{}_L9_1.fq.gz"
ls *gz | sed 's/_L.*//' | uniq | parallel --no-notice -kj40 "cat {}*2.fq.gz > $OUTDIR/{}_L9_2.fq.gz"
