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


# Print what is happening
ls *1.fq.gz | sed 's/_L.*//' | uniq | parallel --no-notice -kj20 "mv {}_LA_1.fq.gz {}_L9_1.fq.gz"
ls *2.fq.gz | sed 's/_L.*//' | uniq | parallel --no-notice -kj20 "mv {}_LA_2.fq.gz {}_L9_2.fq.gz"
