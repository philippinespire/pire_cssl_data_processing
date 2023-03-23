#!/bin/bash -l

#SBATCH --job-name=merge_fixrg
#SBATCH -o merge_fixrg-%j.out 
#SBATCH -p main 
#SBATCH -n 1  
#SBATCH -N 1  
#SBATCH --cpus-per-task=40 

enable_lmod
module load samtools
module load container_env/0.1
module load java
export SINGULARITY_BIND=/home/e1garcia

BAMDIR=$1

BAMPATTERN=*-merged.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG.bam

all_samples=$(ls $BAMDIR/$BAMPATTERN | sed -e 's/-merged\.ssl\.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG\.bam//' -e 's/.*\///g')
all_samples=($all_samples)

sample_name=${all_samples[${SLURM_ARRAY_TASK_ID}]}
echo ${sample_name}

cd ${BAMDIR}

crun java -jar /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/scripts/picard.jar AddOrReplaceReadGroups I=${sample_name}-merged.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG.bam O=${sample_name}-merged.rgfix.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG.bam RGID=${sample_name}-merged RGLB=mergedlibs RGPL=illumina RGPU=unit1 RGSM=${sample_name}-merged 

samtools index ${sample_name}-merged.rgfix.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG.bam

rm ${sample_name}-merged.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG.bam
rm ${sample_name}-merged.ssl.Tbi-C_scaffolds_32R_spades_contam_R1R2ORPH_noisolate-RG.bam.bai
