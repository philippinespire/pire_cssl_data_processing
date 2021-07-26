###running on Rutgers Amarel cluster

###in bash - activate conda momi envelope, generate ind2pop files associating individuals with populations

conda activate momi-env

grep "#CHROM" lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.vcf | cut -d$'\t' -f10- | tr '\t' '\n' > ind.txt 

cat ind.txt | sed 's/Lle-//g' | sed 's/_.*//g' > pop.txt 

paste ind.txt pop.txt > ind2pop.txt 

###enter python3, do allele counts

import momi

vcffile="lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.vcf.gz"
ind2popfile="ind2pop.txt"
outfile="lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.allelecounts" 

with open(ind2popfile) as f: 
	ind2popdict = dict([l.split() for l in f]) 

counts=momi.SnpAlleleCounts.read_vcf(vcf_file=vcffile,ind2pop=ind2popdict,ancestral_alleles=False) 

counts.dump(outfile)

###exit python, zip allele counts file, extract SFS

gzip lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.allelecounts

python -m momi.extract_sfs /home/br450/pire_cssl_data_processing/leiognathus_leuciscus/momi2/lle.sfs.gz 100 /home/br450/pire_cssl_data_processing/leiognathus_leuciscus/momi2/lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.allelecounts.gz

###enter python, import sfs and examine to see if import worked/get % missing data

import momi

sfsfile="/home/br450/pire_cssl_data_processing/leiognathus_leuciscus/momi2/lle.sfs.gz"
sfs = momi.Sfs.load(sfsfile)

print("populations", sfs.populations)
print("percent missing data per population", sfs.p_missing)
print("length", sfs.length)
