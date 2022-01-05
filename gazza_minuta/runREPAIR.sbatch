#!/bin/bash -l

#SBATCH --job-name=repr_fqscrn
#SBATCH -o repr_-%j.out
#SBATCH --time=00:00:00
# cpu =40 for wahab and 32 for turing
#SBATCH --cpus-per-task=40
#SBATCH --mail-user=rene.clark@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

enable_lmod
module load container_env pire_genome_assembly/2021.07.01
#module load java/1.8
#module load bbmap/38.90
#module load parallel

export SINGULARITY_BIND=/home/e1garcia

INDIR=$1   #/home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/fq_fp1_clmp_fp2_fqscrn
OUTDIR=$2    #/home/r3clark/PIRE/pire_cssl_data_processing/gazza_minuta/fq_fp1_clmp_fp2_fqscrn_repaired
THREADS=$3    #40
EXTENSION=.tagged_filter.fastq.gz

mkdir $OUTDIR $OUTDIR/orphans

# repair the paired end files
ls $INDIR/*$EXTENSION | \
sed -e "s/r[12]$EXTENSION//" -e "s/orph$EXTENSION//" -e 's/.*\///g' | \
uniq | \
crun parallel --no-notice -j $THREADS \
        repair.sh \
        in1=$INDIR/{}r1$EXTENSION \
        in2=$INDIR/{}r2$EXTENSION \
        out1=$OUTDIR/{}repr.R1.fq.gz \
        out2=$OUTDIR/{}repr.R2.fq.gz \
        outs=$OUTDIR/orphans/{}repr.orph.fq \
        repair
