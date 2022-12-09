#!/bin/bash -l
#SBATCH --job-name=1mkBGL
#SBATCH -o mkBGL-%j.out
#SBATCH -e mkBGL-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 40

# execute
#sbatch mkBGL.sbatch . Sgr_At24-Ct30_todo4fltr5 . 

enable_lmod
module load container_env bwa-mem2
#export SINGULARITY_BIND=/home/e1garcia

inDIR=$1
#REF=$2
#outDIR=./mkBGL
outFilePREFIX=$2
outDIR=$3

#REFbgz=$(echo $REF | sed 's/\.gz$/\.bgz/' )

#TODO='-doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doPost 2 -doGlf 2 -doSaf 1 -doHWE 1 -doGeno 3'
#test01
#TODO='-doGlf 2 -doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doHWE 1'
#test02
#TODO='-doGlf 2 -doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doHWE 1 -doGeno 3 -doPost 2'
#test03
#TODO='-doGlf 2 -doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doHWE 1 -doGeno 3 -doPost 2 -doCounts 1 -doDepth 1 -doQsDist 1 '
#test04
TODO='-doGlf 2 -doMajorMinor 1 -doMaf 1 -doSnpStat 1 -doHWE 1 -doGeno 3 -doPost 2 -doCounts 1 -doDepth 1 -doQsDist 1 -doEBD 1 '


#from sang, probably from misha matz
#FILTERS='-uniqueOnly 1 -rmTriallelic 0.1 -minMapQ 30 -minQ 30 -minHWEpval 0.05 -maxHetFreq 0.5 -hetbias_pval 1e-5 -minInd 30 -minMaf 0.0062'
#test01
#FILTERS='-uniqueOnly 1 -minMapQ 30 -minQ 20 -minInd 30 -minMaf 0.0062'
#test02
#FILTERS='-uniqueOnly 1 -rmTriallelic 0.1 -minMapQ 30 -minQ 30 -minHWEpval 0.05 -hetbias_pval 0.01 -minInd 30 -minMaf 0.0062'
#test03
#FILTERS='-uniqueOnly 1 -rmTriallelic 0.05 -SNP_pval 0.00001 -minMapQ 30 -minQ 20 -minHWEpval 0.05 -hetbias_pval 0.01 -minInd 30 -minMaf 0.0062'
#test04
#FILTERS='-uniqueOnly 1 -rmTriallelic 0.1 -SNP_pval 0.000001 -minMapQ 50 -minQ 30 -minHWEpval 0.1 -maxHetFreq 0.5 -hetbias_pval 0.5 -sb_pval 0.5 -edge_pval 0.5 -mapQ_pval 0.5 -qscore_pval 0.5 -minInd 41 -minMaf 0.0062'
#test05
FILTERS='-uniqueOnly 1 -rmTriallelic 0.1 -SNP_pval 1e-5 -minMapQ 50 -minQ 30 -minHWEpval 0.1 -maxHetFreq 0.5 -hetbias_pval 0.05 -sb_pval 0.5 -edge_pval 0.1 -mapQ_pval 0.1 -qscore_pval 0.5 -minInd 41 -setMaxDepth 405 -minMaf 0.0062 '
#test06
#FILTERS='-uniqueOnly 1 -rmTriallelic 0.1 -SNP_pval 1e-6 -minMapQ 50 -minQ 30 -minHWEpval 0.2 -maxHetFreq 0.5 -hetbias_pval 0.5 -sb_pval 0.5 -edge_pval 0.5 -mapQ_pval 0.5 -qscore_pval 0.9 -minInd 41 -minMaf 0.0062 '
inDIR=$(echo $inDIR | sed "s/\/$//" )

ls $inDIR/*RG.bam > ${inDIR}/bamNames.txt 

#[ ! -f $REF.fai ] && crun gunzip -c $REF | crun bgzip -@ 40 -c > $REFbgz && REF=$REFbgz && crun samtools faidx $REF 

module load container_env ngsTools

crun angsd -GL 1 \
  $TODO \
  $FILTERS \
  -out ${outDIR}/$outFilePREFIX \
  -bam ${inDIR}/bamNames.txt \
  -nThreads 40 
