#!/bin/bash -l

#SBATCH --job-name=pixy
#SBATCH -o pixy-%j.out
#SBATCH -p main
#SBATCH -c 4
##SBATCH --time=96:00:00
#SBATCH --mail-user=rene.clark@rutgers.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=END

#to run use the following command:
#sbatch pixy.sbatch

cd /home/e1garcia/shotgun_PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/fq_raw

zgrep "^@A" AeA0101*.fq.gz | wc -l >> ~/PIRE/PIRE-Aen-Ham/Aen_raw_reads.txt
zgrep "^@A" AeA0102*.fq.gz | wc -l >> ~/PIRE/PIRE-Aen-Ham/Aen_raw_reads.txt
zgrep "^@A" AeA0103*.fq.gz | wc -l >> ~/PIRE/PIRE-Aen-Ham/Aen_raw_reads.txt
zgrep "^@A" AeA0104*.fq.gz | wc -l >> ~/PIRE/PIRE-Aen-Ham/Aen_raw_reads.txt
zgrep "^@A" AeA0105*.fq.gz | wc -l >> ~/PIRE/PIRE-Aen-Ham/Aen_raw_reads.txt


