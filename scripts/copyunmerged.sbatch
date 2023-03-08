#!/bin/bash -l 

#SBATCH --job-name=copyunmerged-%j 
#SBATCH --output copyunmerged-%j.out 
#SBATCH -p main 
#SBATCH --time=48:00:00 
#SBATCH -c 1 

SPDIR=$1
MRGDIR=$2
DESTDIR=$3

mkdir -p ${SPDIR}/${DESTDIR}

while read file; do
	cp ${SPDIR}/1st_sequencing_run/${file}*-RG* ${SPDIR}/${DESTDIR}
done < ${SPDIR}/${MRGDIR}/run1only_samps.txt

while read file; do
	cp ${SPDIR}/2nd_sequencing_run/${file}*-RG* ${SPDIR}/${DESTDIR}
done < ${SPDIR}/${MRGDIR}/run2only_samps.txt

cp ${SPDIR}/${MRGDIR}/*-RG* ${SPDIR}/${DESTDIR}
