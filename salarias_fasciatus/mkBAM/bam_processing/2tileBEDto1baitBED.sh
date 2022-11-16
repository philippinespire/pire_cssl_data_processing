#!/bin/bash

#SBATCH --job-name=1lineBED
#SBATCH -o singleLineBED-%j.out
#SBATCH -p main
#SBATCH -c 40

ORIGINALBED=$1
singleLineBED=$2

echo "processing $ORIGINALBED"
echo "\nCheck the numbers below" 
echo "\nThe script only works if all numbers are even numbers\n"
echo $(cat $ORIGINALBED | cut -f1 | uniq -c | tr -s " " | cut -d" " -f2 | sort | uniq)
echo "\nIf one number is an odd number (most likely a 1 or 3). Identify the node/chromosome with the error and duplicate the last record of this node to restored the even numbers"

cut -f1,2 $ORIGINALBED | awk 'NR%2==1' > FILE1.temp
cut -f3 $ORIGINALBED | awk 'NR%2==0' > FILE2.temp

paste FILE1.temp FILE2.temp > $singleLineBED

rm FILE1.temp FILE2.temp
