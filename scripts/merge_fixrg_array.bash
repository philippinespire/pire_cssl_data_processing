#!/bin/bash 

#script to fix read group for merged reads

BAMDIR=$1		#directory containing merged bam files. example= /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/gazza_minuta/mkBAMmerge_copy

BAMPATTERN=*-merged.rad.RAW-10-10-RG.bam

SCRIPTPATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

all_samples=$(ls $BAMDIR/$BAMPATTERN | sed -e 's/-merged\.rad\.RAW-10-10-RG\.bam//' -e 's/.*\///g')
all_samples=($all_samples)

sbatch --array=0-$((${#all_samples[@]}-1))%${nodes} $SCRIPTPATH/atlas_pmd_array.sbatch ${BAMDIR}
