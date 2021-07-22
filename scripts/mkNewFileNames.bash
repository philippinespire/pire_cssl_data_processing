#!/bin/bash

# script to rename pire seq files

module load parallel

INFILE=$1    #Lle_CaptureLibraries_SequenceNameDecode.tsv

#get first two letters of seq names

SPCODE=$(tail -n1 $INFILE | cut -c1-2)

# get samp names from decode file, duplicate for r1 and r2 files, and put them in same sort order as sorted fq.gz files
bash  #need this for odu
SAMPNAMES=($(cat <(tail -n +2 $INFILE | sort | uniq) <(tail -n +2 $INFILE | sort | uniq) | sort | cut -f2 | sed -e 's/-\([0-9][0-9][0-9]\)/_\1/' -e 's/\r//'))

# clean up present file names to remove extraneous info and restore missing info
SEQINFO=($(ls fq_fp1_clmp_fp2_fqscrn_repaired/*.fq.gz | sed "s/^fq_fp1.*\(${SPCODE}[AC].....\)_.*_\(L[1-9][0-9]*\)_clmp_fp2_repr/\1-\2-fp1-clmp-fp2-fqscrn-repr/"))

# construct new names
NEWNAMES=($(parallel --no-notice --link -kj2 "echo {1}-{2}" ::: ${SAMPNAMES[@]} ::: ${SEQINFO[@]} ))

# output new names
echo ${NEWR1NAMES[@]} | tr " " "\n" 
