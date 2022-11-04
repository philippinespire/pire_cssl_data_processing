#!/bin/bash

# This scrips summarizes the output of mappedReadStats.sbatch into two tables:
# 1.- "aveReadStats_perPOP.tsv" which gives the average of each stat per population
# 2.- "samples_perMappedReads.tsv" which gives the number of individuals according to the number of mapped reads
# 3.- "samples_perCVG.tsv" which gives the number of individuals according to the meandepth_wcvg per population
# contact: Dr. Eric Garcia e1garcia@odu.edu

# Execute
# bash popsummary_mappedReadStats.sh <output file of mappedReadStats.sbatch"

INDIR=$1
INFILE=$2
OUTDIR=$3

echo -e "This scrips provides population summaries from the output of mappedReadStats.sbatch into 3 tables:\n1.- aveReadStats_perPOP.tsv, which gives the average of each stat per population\n2.- samples_perMappedReads.tsv, which gives the number of individuals according to the number of mapped reads\n3.- samples_perCVG.tsv, which gives the number of individuals according to the meandepth_wcvg per population"
 
echo -e "\nCreating aveReadStats_perPOP.tsv"
# Create file with header
echo -e "Population\tn_samples\tAVG_numreads\tAVG_meanreadlength\tAVG_meandepth_wcvg\tAVG_numpos\tAVG_numpos_wcvg\tAVG_meandepth\tAVG_pctpos_wcvg"  > $OUTDIR/aveReadStats_perPOP.tsv

# Fetch the populations
cat $INDIR/$INFILE | tail -n+2 | sed -e 's/.*\///' -e 's/_.*//' | sort | uniq > $OUTDIR/pops.temp

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
		echo -e "$pop\t$nSAMPLES\t$aveCOL2\t$aveCOL3\t$aveCOL4\t$aveCOL5\t$aveCOL6\t$aveCOL7\t$aveCOL8" >> $OUTDIR/aveReadStats_perPOP.tsv
done


echo -e "\nCreating samples_perMappedReads.tsv"

# Create file with header
echo -e "Population\ttotal_n_samples\tn_mappedReads<100k\tn_100-250k\tn_250-500k\tn_500k-1M\tn_1-2M\tn_>2M" > $OUTDIR/samples_perMappedReads.tsv

# Populate file per population
for pop in $(cat pops.temp)
        do 
                nTSAMPLES=$(grep "$pop" $INFILE | wc -l)
                nSAMPLES_less100=$(grep "$pop" $INFILE | awk -F "\t" '{ if($2 < 100000) { print } }'  | wc -l)
                nSAMPLES_100_250=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($2 >= 100000) && ($2 < 250000)) { print } }' | wc -l)
                nSAMPLES_250_500=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($2 >= 250000) && ($2 < 500000)) { print } }' | wc -l)
                nSAMPLES_500_1M=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($2 >= 500000) && ($2 < 1000000)) { print } }' | wc -l)
                nSAMPLES_1_2M=$(grep "$pop" $INFILE | awk -F "\t" '{ if(($2 >= 1000000) && ($2 < 2000000)) { print } }' | wc -l)
                nSAMPLES_more2M=$(grep "$pop" $INFILE | awk  -F "\t" '{ if($2 > 2000000) { print } }'  | wc -l)
                echo -e "$pop\t$nTSAMPLES\t$nSAMPLES_less100\t$nSAMPLES_100_250\t$nSAMPLES_250_500\t$nSAMPLES_500_1M\t$nSAMPLES_1_2M\t$nSAMPLES_more2M" >> $OUTDIR/samples_perMappedReads.tsv
done


echo -e "\nCreating samples_perCVG.tsv"

# Create file with header
echo -e "Population\ttotal_n_samples\tn_meandepth_wcvg<10x\tn_10x-20x\tn_20x-30x\tn_30x-40x\tn_40x-50x\tn_>50x" > $OUTDIR/samples_perCVG.tsv

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
                echo -e "$pop\t$nTSAMPLES\t$nSAMPLES_less10\t$nSAMPLES_10_20\t$nSAMPLES_20_30\t$nSAMPLES_30_40\t$nSAMPLES_40_50\t$nSAMPLES_more50" >> $OUTDIR/samples_perCVG.tsv
done

rm $OUTDIR/pops.temp

echo -e "\nPrinting aveReadStats_perPOP.tsv:"
cat aveReadStats_perPOP.tsv | column -ts $'\t'
echo -e "\nPrinting samples_perMappedReads.tsv"
cat samples_perMappedReads.tsv | column -ts $'\t'
echo -e "\nPrinting samples_perCVG.tsv:"
cat samples_perCVG.tsv | column -ts $'\t'
echo -e "\n Saving summaries into $OUTDIR/out_popsummary_mappedReadsStats.log"

# Create out_*_.log file
cat <(\
	echo -e "This scrips provides population summaries from the output of mappedReadStats.sbatch into 3 tables:\n1.- aveReadStats_perPOP.tsv, which gives the average of each stat per population\n2.- samples_perMappedReads.tsv, which gives the number of individuals according to the number of mapped reads\n3.- samples_perCVG.tsv, which gives the number of individuals according to the meandepth_wcvg per population"
        echo -e "\nContact:Dr. Eric Garcia, e1garcia@odu.edu") <(\
	echo -e "\nINFILE=$INFILE") <(\
	echo -e "\nPrinting aveReadStats_perPOP.tsv:") <(\
	cat aveReadStats_perPOP.tsv | column -ts $'\t') <(\
	echo -e "\nPrinting samples_perMappedReads.tsv") <(\
	cat samples_perMappedReads.tsv | column -ts $'\t') <(\
	echo -e "\nPrinting samples_perCVG.tsv:") <(\
	cat samples_perCVG.tsv | column -ts $'\t') > $OUTDIR/out_popsummary_mappedReadsStats.log

