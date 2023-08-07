#!/bin/bash -l 

#SBATCH --job-name=mergebams-%j 
#SBATCH --output mergebams-%j.out 
#SBATCH -p main 
#SBATCH --time=48:00:00 
#SBATCH -c 1 
#SBATCH --exclusive=user 

enable_lmod 
module load container_env samtools
export SINGULARITY_BIND=/home/e1garcia 

speciesdir=${1} 

samps2merge=$( cat ${speciesdir}/mergebams_run1run2/run1run2_samps.txt ) 
samps2merge=($samps2merge) 

sample_name=${samps2merge[${SLURM_ARRAY_TASK_ID}]}
echo ${sample_name} 

crun.samtools samtools merge ${speciesdir}/mergebams_run1run2/${sample_name}-merged-RG.bam ${speciesdir}/1st_sequencing_run/mkBAM/${sample_name}*RG.bam ${speciesdir}/2nd_sequencing_run/mkBAM/${sample_name}*RG.bam 

crun.samtools samtools index ${speciesdir}/mergebams_run1run2/${sample_name}-merged-RG.bam
