#!/bin/bash 

#script to fix read group for merged reads

BAMDIR=$1		#directory containing merged bam files. example= /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge_copy

BAMPATTERN=*-merged-RG.bam

SCRIPTPATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

all_samples=$(ls $BAMDIR/$BAMPATTERN | sed -e 's/-merged-RG\.bam//' -e 's/.*\///g')
all_samples=($all_samples)

sbatch --array=0-$((${#all_samples[@]}-1))%${nodes} $SCRIPTPATH/merge_fixrg_array.sbatch ${BAMDIR}
