#!/bin/bash
#SBATCH --job-name=mkBGL
#SBATCH -o mkBGL-%j.out
#SBATCH -e mkBGL-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 40

# to run
# sbatch mkBGL.sbatch 154 25 115
# sbatch mkBGL.sbatch numInd pctOfTotInd minInd

enable_lmod
module load container_env ngsTools
#export SINGULARITY_BIND=/home/bdang

# command line args
inDIR=$(echo $1 | sed "s/\/$//" )    # path to bam files
bamLIST=${inDIR}/bamNames.txt
outDIR=./mkBGL   # path to dir where output will be placed
outFilePREFIX=$2   # prefix on output files, NOT A PATH
#REF=$3     # path to ref genome

#TODO='-GL 1 -doGlf 2 -doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doHWE 1 -doGeno 3 -doPost 2 -doCounts 1 -doDepth 1 -doQsDist 1 -doEBD 1 '
TODO='-doGlf 2 -doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doHWE 1 -doGeno 3 -doPost 2 -doCounts 1 -doDepth 1 -doQsDist 1 -doEBD 1 '


FILTERS='-uniqueOnly 1 -rmTriallelic 0.1 -SNP_pval 1e-5 -minMapQ 50 -minQ 30 -minHWEpval 0.1 -maxHetFreq 0.5 -hetbias_pval 0.05 -sb_pval 0.5 -edge_pval 0.1 -mapQ_pval 0.1 -qscore_pval 0.5 -minInd 41 -setMaxDepth 405 -minMaf 0.0062 '

# set up dirs and files
ls $inDIR/*.bam > ${inDIR}/bamNames.txt 
mkdir -p $outDIR
bamLIST=${inDIR}/bamNames.txt

# run angsd, you may need to delete crun if you aren't using containers
crun angsd -GL 1 \
  $TODO \
  $FILTERS \
  -out ${outDIR}/$outFilePREFIX \
  -bam ${inDIR}/bamNames.txt \
  -nThreads 40 

zcat ${outDIR}/${outFilePREFIX}.mafs.gz | cut -f 1,2 | tail -n +2 > ${outDIR}/${outFilePREFIX}.pos

crun angsd sites index ${outDIR}/${outFilePREFIX}.pos
