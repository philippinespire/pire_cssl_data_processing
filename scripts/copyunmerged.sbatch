#!/bin/bash -l 

#SBATCH --job-name=copyunmerged-%j 
#SBATCH --output copyunmerged-%j.out 
#SBATCH -p main 
#SBATCH --time=48:00:00 
#SBATCH -c 1 

## script to use after merging .bam files from two different sequencing runs to copy merged and unmerged files to a common diretory
## assuming original bam files are in mkBAM folders within 1st_sequencing_run and 2nd_sequencing_run, and merged files are in mergebams_run1run2
## syntax: sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/copyunmerged.sbatch <species directory> <merged bams directory> <directory where you run mkVCF on merged + unmerged files>
## e.g. sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/copyunmerged.sbatch /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/taeniamia_biguttata mergebams_run1run2 mkBAMmerge

SPDIR=$1
MRGDIR=$2
DESTDIR=$3

mkdir -p ${SPDIR}/${DESTDIR}

while read file; do
	cp ${SPDIR}/1st_sequencing_run/mkBAM/${file}*-RG* ${SPDIR}/${DESTDIR}
done < ${SPDIR}/${MRGDIR}/run1only_samps.txt

while read file; do
	cp ${SPDIR}/2nd_sequencing_run/mkBAM/${file}*-RG* ${SPDIR}/${DESTDIR}
done < ${SPDIR}/${MRGDIR}/run2only_samps.txt

cp ${SPDIR}/${MRGDIR}/*-RG* ${SPDIR}/${DESTDIR}
