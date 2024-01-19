
# goto compute node

```
salloc
```

# load vcftools
```
enable_lmod
module load container_env ddocent
```

# set variables

```
bash
VCFFILE=lle.D.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr17.1.recode.vcf
VCFFILE=lle.B.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.Fltr15.5.recode.vcf
VCFFILE=../mkBAM/TotalRawSNPs.ssl.Lle-C-3NR-R1R2ORPH-contam-noisolate-off.vcf
FILE_PREFIX=$(echo $VCFFILE | sed -e 's/vcf//' -e 's/.*\///g')
JUNK_PATTERN=-L1-fp1-clmp-fp2-fqscrn-repr
```

# goto dir

```
cd/cbird/pire_cssl_data_processing/leiognathus_leuciscus/filterVCF
```

# make header

```
paste <(echo -e 'chrom\tpos\tref\talt\tqual') <(crun vcf-query $VCFFILE -l | tr "\n" "\t" | sed "s/$JUNK_PATTERN//g") > individuals.tsv
```

# extract columns of info from VCF (test file limits records to 100 snps)

format of resulting files is: chrom, pos, ref, alt, qual, ind1, ind2...

```
#cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GL]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}GL.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}AD.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}GT.tsv
```

# extract columns of info from VCF (no limits)

format of resulting files is: chrom, pos, ref, alt, qual, ind1, ind2...

```
#cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GL]\n' ) | sed 's/\t$//' > ${FILE_PREFIX}GL.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' ) | sed 's/\t$//' > ${FILE_PREFIX}AD.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' ) | sed 's/\t$//' > ${FILE_PREFIX}GT.tsv
```

The genotype likelihoods are not needed and create a much larger file than just the genotypes

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Aen
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# goto dir

```
cd/cbird/pire_cssl_data_processing/atherinomorus_endrachtensis/filterVCF_ceb
export SINGULARITY_BIND=/home/r3clark  
```

# set variables

```
VCFFILE=Aen.A3.rad.RAW-6-6.Fltr15.9.recode.vcf
VCFFILE=/home/r3clark/PIRE/pire_cssl_data_processing/atherinomorus_endrachtensis/mkBAM/TotalRawSNPs.rad.RAW-6-6.vcf
VCFFILE=Aen.A3.rad.RAW-6-6.Fltr07.19.vcf
JUNK_PATTERN=_.*-..-.*-.*_.*_L1_clmp_fp2_repr
NUM_CHR_ID=21
FILE_PREFIX=$(echo $VCFFILE | sed -e 's/vcf//' -e 's/.*\///g')
```

# make header

```
paste <(echo -e 'chrom\tpos\tref\talt\tqual') <(crun vcf-query $VCFFILE -l | cut -c1-$NUM_CHR_ID | tr "\n" "\t" ) > individuals.tsv
```

# extract columns of info from VCF (test file limits records to 100 snps)

format of resulting files is: chrom, pos, ref, alt, qual, ind1, ind2...

```
#cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GL]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}GL.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}AD.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' | head -n 100 ) | sed 's/\t$//' > ${FILE_PREFIX}GT.tsv
```

# extract columns of info from VCF (no limits)

format of resulting files is: chrom, pos, ref, alt, qual, ind1, ind2...

```
#cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GL]\n' ) | sed 's/\t$//' > ${FILE_PREFIX}GL.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%AD]\n' ) | sed 's/\t$//' > ${FILE_PREFIX}AD.tsv
cat individuals.tsv <(crun vcf-query $VCFFILE -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL[\t%GT]\n' ) | sed 's/\t$//' > ${FILE_PREFIX}GT.tsv
```

The genotype likelihoods are not needed and create a much larger file than just the genotypes