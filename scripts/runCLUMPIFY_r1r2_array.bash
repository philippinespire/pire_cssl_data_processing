#!/bin/bash

#Pass in the maximum number of nodes to use at once
nodes=$4

FQPATTERN=*r1.fq.gz
INDIR=$1
OUTDIR=$2
TMPDIR=$3

all_samples=$(ls $INDIR/$FQPATTERN | \
	sed -e 's/r1\.fq\.gz//' -e 's/.*\///g')
all_samples=($all_samples)

$(sbatch --array=0-$((${#all_samples[@]}-1))%${nodes} runCLUMPIFY_r1r2_array.sbatch ${INDIR} ${OUTDIR} ${TMPDIR} ${FQPATTERN}
