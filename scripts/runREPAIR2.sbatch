
Skip to content
Pull requests
Issues
Marketplace
Explore
@cbird808
philippinespire /
denovo_genome_assembly
Private

3
0

    0

Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights

    Settings

denovo_genome_assembly/pre-assembly_processing/runREPAIR2.sbatch
e1garcia updated decontamination
Latest commit ce48800 14 days ago
History
1 contributor
executable file 38 lines (32 sloc) 941 Bytes
#!/bin/bash -l

#SBATCH --job-name=repr_fqscrn
#SBATCH -o repair_fastqscreen_-%A.out
#SBATCH -p main
# Set cpus to 32 for Turing or 40 for Wahab
#SBATCH --cpus-per-task=40
# have to calculate 0 to number of files in $inputs var + 1
#SBATCH --array=0-160
## use this on turing only
##SBATCH --spread-job

enable_lmod
module load container_env pire_genome_assembly/2021.03.25
#module load java/1.8
#module load bbmap/38.90
#module load parallel

export SINGULARITY_BIND=/home/e1garcia

TEMPDIR=/scratch-lustre/cbird
INDIR=.
OUTDIR=.
EXTENSION=.tagged_filter.fastq
INFILES=($(ls $INDIR/*$EXTENSION | \
  sed "s/r[12]$EXTENSION//" | \
  uniq))

mkdir $OUTDIR

for i in `seq 3`; do
  crun repair.sh \
        in1="${inputs[$SLURM_ARRAY_TASK_ID]}r1$EXTENSION" \
        in2="${inputs[$SLURM_ARRAY_TASK_ID]}r2$EXTENSION" \
        out1=$OUTDIR/{}repr_R1.fq \
        out2=$OUTDIR/{}repr_R2.fq \
        outs=$OUTDIR/{}repr_orph.fq \
        repair

    © 2021 GitHub, Inc.
    Terms
    Privacy
    Security
    Status
    Docs

    Contact GitHub
    Pricing
    API
    Training
    Blog
    About

Loading complete
