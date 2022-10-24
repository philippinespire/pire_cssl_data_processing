#!/bin/bash

# This scrips summarizes the output of mappedReadStats.sbatch into two tables:
# 1.- "aveReadStats_perPOP.tsv" which gives the average of each stat per population
# 2.- "samples_perCVG.tsv" which gives the number of individuals according to the meandepth_wcvg per population
# contact: Dr. Eric Garcia e1garcia@odu.edu

# Execute
# bash mappedReadSummary.sh <output file of mappedReadStats.sbatch"

INFILE=$1

echo -e "This scrips summarizes the output of mappedReadStats.sbatch into two tables:\n1.- aveReadStats_perPOP.tsv, which gives the average of each stat per population\n2.- samples_perCVG.tsv, which gives the number of individuals according to the meandepth_wcvg per population"
 
echo -e "\nCreating aveReadStats_perPOP.tsv"
# Create file with header
echo -e "Population\tn_samples\tAVG_numreads\tAVG_meanreadlength\tAVG_meandepth_wcvg\tAVG_numpos\tAVG_numpos_wcvg\tAVG_meandepth\tAVG_pctpos_wcvg"  >aveReadStats_perPOP.tsv

# Fetch the populations
cat $INFILE | tail -n+2 | sed -e 's/.*\///' -e 's/_.*//' | sort | uniq > pops.temp

# Populate file per population
for pop in $(cat pops.temp)
	do 
		nSAMPLES=$(grep "$pop" $INFILE  | wc -l)
		aveCOL2=$(grep "$pop" $INFILE | awk '{ total += $2 } END { print total/NR }')
		aveCOL3=$(grep "$pop" $INFILE | awk '{ total += $3 } END { print total/NR }')
		aveCOL4=$(grep "$pop" $INFILE | awk '{ total += $4 } END { print total/NR }')
		aveCOL5=$(grep "$pop" $INFILE | awk '{ total += $5 } END { print total/NR }')
		aveCOL6=$(grep "$pop" $INFILE | awk '{ total += $6 } END { print total/NR }')
		aveCOL7=$(grep "$pop" $INFILE | awk '{ total += $7 } END { print total/NR }')
		aveCOL8=$(grep "$pop" $INFILE | awk '{ total += $8 } END { print total/NR }')
		echo -e "$pop\t$nSAMPLES\t$aveCOL2\t$aveCOL3\t$aveCOL4\t$aveCOL5\t$aveCOL6\t$aveCOL7\t$aveCOL8" >> aveReadStats_perPOP.tsv
done

echo -e "\nCreating samples_perCVG.tsv"

# Create file with header
echo -e "Population\ttotal_n_samples\tn_<10x\tn_10x-20x\tn_20x-30x\tn_30x-40x\tn_40x-50x\tn_>50x" > samples_perCVG.tsv

# Populate file per population
for pop in $(cat pops.temp)
        do 
                nTSAMPLES=$(grep "$pop" $INFILE | wc -l)
                nSAMPLES_less10=$(grep "$pop" $INFILE | awk -F "\t" '{ if($4 < 10) { print } }'  | wc -l)
                nSAMPLES_10_20=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($4 >= 10) && ($4 < 20)) { print } }' | wc -l)
                nSAMPLES_20_30=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($4 >= 20) && ($4 < 30)) { print } }' | wc -l)
                nSAMPLES_30_40=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($4 >= 30) && ($4 < 40)) { print } }' | wc -l)
                nSAMPLES_40_50=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($4 >= 40) && ($4 < 50)) { print } }' | wc -l)
                nSAMPLES_more50=$(grep "$pop" $INFILE | awk  -F "\t" '{ if($4 > 50) { print } }'  | wc -l)
                echo -e "$pop\t$nTSAMPLES\t$nSAMPLES_less10\t$nSAMPLES_10_20\t$nSAMPLES_20_30\t$nSAMPLES_30_40\t$nSAMPLES_40_50\t$nSAMPLES_more50" >> samples_perCVG.tsv
done

rm pops.temp

echo -e "\nPrinting aveReadStats_perPOP.tsv:"
cat aveReadStats_perPOP.tsv | column -ts $'\t'
echo -e "\nPrinting samples_perCVG.tsv:"
cat samples_perCVG.tsv | column -ts $'\t'

#cat AVG_perPOP.tsv distribution_perCVG.tsv | sed 's/Population\tt/\n\.\.\.\nPopulation\tt/' | column -ts $'\t' | less 
